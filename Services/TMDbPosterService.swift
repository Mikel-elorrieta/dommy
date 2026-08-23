import Foundation

/// Descarga pósters reales desde TMDb (The Movie Database) y los cachea
/// localmente para no repetir peticiones de red en cada apertura de la app.
///
/// TMDb permite este uso (no comercial, con atribución) de forma gratuita:
/// https://www.themoviedb.org/documentation/api/terms-of-use
///
/// IMPORTANTE: necesitas tu propia API key gratuita de TMDb, rellénala en
/// TMDbConfig.swift. Sin ella, este servicio simplemente no encuentra nada
/// y la app sigue funcionando con los placeholders de siempre — no rompe nada.
actor TMDbPosterService {
    static let shared = TMDbPosterService()

    private let session = URLSession.shared
    private let imageBaseURL = "https://image.tmdb.org/t/p/w342"
    private let cacheDefaultsKey = "com.mcurewatch.tmdb.posterCache.v1"

    /// "none" es un centinela: significa "ya se buscó y TMDb no tiene poster
    /// para esto", para no volver a preguntar cada vez que se abre la app.
    private let notFoundSentinel = "none"

    private var memoryCache: [String: String] = [:]
    private var didLoadDiskCache = false

    private func loadDiskCacheIfNeeded() {
        guard !didLoadDiskCache else { return }
        didLoadDiskCache = true
        if let saved = UserDefaults.standard.dictionary(forKey: cacheDefaultsKey) as? [String: String] {
            memoryCache = saved
        }
    }

    private func persistCache() {
        UserDefaults.standard.set(memoryCache, forKey: cacheDefaultsKey)
    }

    /// Devuelve la URL del póster para un título, o nil si no se encontró
    /// o no hay API key configurada. Cachea el resultado (incluido "no encontrado")
    /// para que solo se consulte la red una vez por título, para siempre.
    func posterURL(for title: MCUTitle) async -> URL? {
        loadDiskCacheIfNeeded()

        if let cached = memoryCache[title.id] {
            return cached == notFoundSentinel ? nil : URL(string: cached)
        }

        guard !TMDbConfig.apiKey.isEmpty, TMDbConfig.apiKey != "PON_AQUI_TU_API_KEY_TMDB" else {
            return nil
        }

        let posterPath = await fetchPosterPath(for: title)
        memoryCache[title.id] = posterPath ?? notFoundSentinel
        persistCache()

        guard let posterPath else { return nil }
        return URL(string: imageBaseURL + posterPath)
    }

    private func fetchPosterPath(for title: MCUTitle) async -> String? {
        let endpoint = title.mediaType == .movie || title.mediaType == .special ? "movie" : "tv"
        var components = URLComponents(string: "https://api.themoviedb.org/3/search/\(endpoint)")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: TMDbConfig.apiKey),
            URLQueryItem(name: "query", value: title.title),
            URLQueryItem(name: "language", value: "es-ES"),
        ]
        guard let url = components?.url else { return nil }

        do {
            let (data, _) = try await session.data(from: url)
            let decoded = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)

            // Prioriza el resultado cuyo año coincide con el nuestro (evita falsos
            // positivos con remakes/homónimos); si ninguno coincide, coge el primero.
            let bestMatch = decoded.results.first { result in
                guard let resultYear = result.year else { return false }
                return resultYear == title.releaseYear
            } ?? decoded.results.first

            return bestMatch?.poster_path
        } catch {
            return nil
        }
    }
}

private struct TMDbSearchResponse: Decodable {
    let results: [TMDbResult]
}

private struct TMDbResult: Decodable {
    let poster_path: String?
    let release_date: String?
    let first_air_date: String?

    var year: Int? {
        let dateString = release_date ?? first_air_date
        guard let dateString, dateString.count >= 4 else { return nil }
        return Int(dateString.prefix(4))
    }
}
