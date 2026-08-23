import Foundation

/// Pon aquí tu API key gratuita de TMDb (The Movie Database).
///
/// Cómo conseguirla (2 minutos, gratis, sin tarjeta):
/// 1. Crea una cuenta en https://www.themoviedb.org/signup
/// 2. Ve a tu perfil → Settings → API → "Request an API Key"
/// 3. Elige "Developer", rellena el formulario (puedes poner "personal project /
///    non-commercial" y el nombre de la app: MCU Rewatch)
/// 4. Copia la "API Key (v3 auth)" que te dan y pégala abajo, entre las comillas.
///
/// Mientras esto diga "PON_AQUI_TU_API_KEY_TMDB", la app simplemente no
/// descargará pósters y seguirá mostrando los placeholders — no rompe nada
/// dejarlo vacío.
enum TMDbConfig {
    static let apiKey = "336c44e27755066ce658645484a9b42a"
}
