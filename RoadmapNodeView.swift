import SwiftUI

struct RoadmapNodeView: View {
    let title: MCUTitle
    let isNext: Bool
    let onMarkSeen: () -> Void
    let onMarkRewatch: () -> Void
    let onUnmarkSeen: () -> Void
    let onUnmarkRewatch: () -> Void

    @State private var justCompleted = false

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            connectorRail

            NavigationLink {
                TitleDetailView(
                    title: title,
                    onMarkSeen: onMarkSeen,
                    onMarkRewatch: onMarkRewatch,
                    onUnmarkSeen: onUnmarkSeen,
                    onUnmarkRewatch: onUnmarkRewatch
                )
            } label: {
                HStack(spacing: 14) {
                    ZStack(alignment: .bottomTrailing) {
                        PosterView(title: title)
                            .frame(width: 64, height: 96)
                            .opacity(posterOpacity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isNext ? Color.yellow : .clear, lineWidth: 2.5)
                            )
                            .scaleEffect(justCompleted ? 1.08 : 1.0)

                        stateBadge
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("#\(title.releaseOrder)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                        Text(title.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(title.isReleased ? .primary : .secondary)
                            .lineLimit(2)
                        HStack(spacing: 6) {
                            Text(String(title.releaseYear))
                            Text("·")
                            Text(title.mediaType.rawValue)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        tagLabel
                    }
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(isNext ? Color.yellow.opacity(0.08) : Color.white.opacity(0.04))
                )
            }
            .buttonStyle(.plain)
        }
        .onChange(of: title.isRewatchedDoomsday) { _, newValue in
            guard newValue else { return }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { justCompleted = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { justCompleted = false }
            }
        }
    }

    private var posterOpacity: Double {
        switch title.watchState {
        case .rewatchedDoomsday: return 1.0
        case .seenBefore: return 0.85
        case .notSeen: return title.isReleased ? (isNext ? 1.0 : 0.6) : 0.3
        }
    }

    @ViewBuilder
    private var stateBadge: some View {
        switch title.watchState {
        case .rewatchedDoomsday:
            Image(systemName: "flame.circle.fill")
                .font(.system(size: 20))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .orange)
                .background(Circle().fill(.white).frame(width: 16, height: 16))
                .offset(x: 4, y: 4)
        case .seenBefore:
            Image(systemName: "eye.circle.fill")
                .font(.system(size: 20))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .green)
                .background(Circle().fill(.white).frame(width: 16, height: 16))
                .offset(x: 4, y: 4)
        case .notSeen:
            if !title.isReleased {
                Image(systemName: "lock.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(5)
                    .background(Circle().fill(.black.opacity(0.6)))
                    .offset(x: 4, y: 4)
            }
        }
    }

    @ViewBuilder
    private var tagLabel: some View {
        let categoryTag: (String, Color)? = {
            switch title.category {
            case .multiverse: return ("MULTIVERSE", .blue)
            case .defenders: return ("DEFENDERS", .purple)
            case .agentCarter: return ("AGENT CARTER", .pink)
            default: return nil
            }
        }()
        let stateTag: (String, Color)? = {
            switch title.watchState {
            case .rewatchedDoomsday: return ("🔥 REWATCH", .orange)
            case .seenBefore: return ("🟢 PENDIENTE DE REWATCH", .green)
            case .notSeen:
                if isNext { return ("SIGUIENTE PARADA", .yellow) }
                if !title.isReleased { return ("PRÓXIMAMENTE", .gray) }
                return nil
            }
        }()

        // Si hay dos etiquetas, se apilan en dos filas para que nunca se
        // corten ni se salgan del ancho disponible en pantallas estrechas
        // (iPhone SE / mini). Con una sola etiqueta, cabe holgada en una fila.
        if let categoryTag, let stateTag {
            VStack(alignment: .leading, spacing: 3) {
                pill(categoryTag.0, categoryTag.1)
                pill(stateTag.0, stateTag.1)
            }
        } else if let tag = categoryTag ?? stateTag {
            pill(tag.0, tag.1)
        }
    }

    private func pill(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .heavy))
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(color.opacity(0.25))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var connectorRail: some View {
        Rectangle()
            .fill(title.isRewatchedDoomsday ? Color.orange : Color.gray.opacity(0.3))
            .frame(width: 3)
    }
}
