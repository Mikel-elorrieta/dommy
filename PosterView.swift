import SwiftUI
import UIKit

/// Muestra el póster real de TMDb si se pudo descargar (o si hay un asset
/// local con el nombre de posterAssetName), y si no, cae a un placeholder
/// generado con gradiente + icono + título. Nunca se queda "roto" ni en blanco.
struct PosterView: View {
    let title: MCUTitle
    var cornerRadius: CGFloat = 12

    @State private var remoteImage: UIImage?
    @State private var didAttemptLoad = false

    var body: some View {
        ZStack {
            if let remoteImage {
                Image(uiImage: remoteImage)
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
            } else if UIImage(named: title.posterAssetName) != nil {
                Image(title.posterAssetName)
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: title.id) {
            guard !didAttemptLoad else { return }
            didAttemptLoad = true
            guard let url = await TMDbPosterService.shared.posterURL(for: title) else { return }
            guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
            guard let image = UIImage(data: data) else { return }
            remoteImage = image
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 6) {
                Image(systemName: title.mediaType == .series ? "tv.fill" : "film.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
                Text(title.title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .padding(.horizontal, 6)
            }
        }
        .aspectRatio(2/3, contentMode: .fill)
    }

    private var gradientColors: [Color] {
        switch title.category {
        case .mcuCore, .finalDestination:
            return [Color(red: 0.65, green: 0.08, blue: 0.08), Color(red: 0.1, green: 0.02, blue: 0.02)]
        case .multiverse:
            return [Color(red: 0.15, green: 0.25, blue: 0.55), Color(red: 0.05, green: 0.05, blue: 0.15)]
        case .defenders:
            return [Color(red: 0.25, green: 0.1, blue: 0.35), Color(red: 0.05, green: 0.02, blue: 0.1)]
        case .agentCarter:
            return [Color(red: 0.45, green: 0.1, blue: 0.25), Color(red: 0.1, green: 0.02, blue: 0.08)]
        }
    }
}
