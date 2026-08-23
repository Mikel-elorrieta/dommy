import SwiftUI
import SwiftData

struct TitleDetailView: View {
    @Bindable var title: MCUTitle
    let onMarkSeen: () -> Void
    let onMarkRewatch: () -> Void
    let onUnmarkSeen: () -> Void
    let onUnmarkRewatch: () -> Void

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "es_ES")
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PosterView(title: title)
                    .frame(width: 180, height: 270)
                    .shadow(radius: 12)

                VStack(spacing: 6) {
                    Text(title.title)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)
                    Text("\(title.releaseYear) · \(title.mediaType.rawValue) · \(title.runtimeFormatted)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(title.phase.rawValue)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                }

                stateSummary

                if !title.isReleased {
                    Label("Se estrena el \(Self.dateFormatter.string(from: title.releaseDate))", systemImage: "lock.fill")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    actionButtons
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundStyle(.white)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var stateSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            stateRow(
                icon: title.isSeenBefore ? "checkmark.circle.fill" : "circle",
                color: title.isSeenBefore ? .green : .secondary,
                text: title.isSeenBefore
                    ? "Vista anteriormente" + (title.seenBeforeDate.map { " · \(Self.dateFormatter.string(from: $0))" } ?? "")
                    : "No vista todavía"
            )
            stateRow(
                icon: title.isRewatchedDoomsday ? "flame.circle.fill" : "circle",
                color: title.isRewatchedDoomsday ? .orange : .secondary,
                text: title.isRewatchedDoomsday
                    ? "Rewatch Doomsday completado" + (title.rewatchDate.map { " · \(Self.dateFormatter.string(from: $0))" } ?? "")
                    : "Pendiente de Rewatch Doomsday"
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func stateRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).foregroundStyle(color)
            Text(text).font(.subheadline)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button(action: onMarkSeen) {
                Label(
                    title.isSeenBefore ? "✓ Ya la había visto" : "✓ YA LA HE VISTO",
                    systemImage: "checkmark"
                )
                .font(.subheadline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(title.isSeenBefore ? Color.green.opacity(0.25) : Color.white.opacity(0.1))
                .foregroundStyle(title.isSeenBefore ? .green : .white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(title.isSeenBefore)

            // Deshacer "vista anteriormente" — solo visible cuando hay algo que
            // deshacer. Al quitarlo, el modelo resetea también el rewatch en
            // cascada (no puede haber rewatch de algo no visto), así que avisamos.
            if title.isSeenBefore {
                Button(role: .destructive, action: onUnmarkSeen) {
                    Text(title.isRewatchedDoomsday ? "Quitar marca (también quita el Rewatch)" : "Quitar marca de \"vista\"")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red.opacity(0.85))
            }

            Button(action: onMarkRewatch) {
                Label(
                    title.isRewatchedDoomsday ? "🔥 Rewatch Doomsday ✓" : "🔄 REWATCH DOOMSDAY",
                    systemImage: "flame.fill"
                )
                .font(.subheadline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(title.isRewatchedDoomsday ? Color.orange.opacity(0.3) : Color.orange)
                .foregroundStyle(title.isRewatchedDoomsday ? .orange : .black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(title.isRewatchedDoomsday)

            // Deshacer SOLO el rewatch, conservando "vista anteriormente".
            if title.isRewatchedDoomsday {
                Button(role: .destructive, action: onUnmarkRewatch) {
                    Text("Quitar marca de Rewatch (mantiene \"vista\")")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red.opacity(0.85))
            }
        }
    }
}
