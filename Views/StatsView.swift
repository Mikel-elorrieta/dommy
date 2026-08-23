import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \MCUTitle.releaseOrder) private var allTitles: [MCUTitle]
    @ObservedObject var roadmapViewModel: RoadmapViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    historySection
                    doomsdaySection
                }
                .padding(.vertical)
            }
            .background(Color.black.ignoresSafeArea())
            .foregroundStyle(.white)
            .navigationTitle("")
        }
        .preferredColorScheme(.dark)
    }

    private var scoped: [MCUTitle] {
        let active = roadmapViewModel.activeCategories()
        return allTitles.filter { active.contains($0.category) }
    }

    private var historySection: some View {
        let seenBefore = scoped.filter { $0.isSeenBefore }.count
        let neverSeen = scoped.filter { !$0.isSeenBefore }.count

        return VStack(alignment: .leading, spacing: 12) {
            Text("MI HISTORIAL")
                .font(.title3.weight(.heavy))
                .padding(.horizontal)
            grid([
                ("Ya había visto", "\(seenBefore)"),
                ("Nunca vistos", "\(neverSeen)"),
            ])
            .padding(.horizontal)
        }
    }

    private var doomsdaySection: some View {
        let roadmapItems = roadmapViewModel.roadmapTitles(from: allTitles)
        let stats = DoomsdayCalculator.stats(for: roadmapItems)
        let progress = roadmapViewModel.progress(for: allTitles)
        let hoursCompleted = roadmapItems.filter { $0.isRewatchedDoomsday }.reduce(0) { $0 + $1.runtimeMinutes } / 60
        let hoursRemaining = stats.minutesRemaining / 60
        let lastRewatch = roadmapItems
            .filter { $0.isRewatchedDoomsday }
            .sorted { ($0.rewatchDate ?? .distantPast) > ($1.rewatchDate ?? .distantPast) }
            .first
        let nextRewatch = roadmapViewModel.nextStop(from: allTitles)
        let percent = progress.total == 0 ? 0 : Double(progress.completed) / Double(progress.total)

        return VStack(alignment: .leading, spacing: 12) {
            Text("ROAD TO DOOMSDAY")
                .font(.title3.weight(.heavy))
                .padding(.horizontal)
            grid([
                ("Rewatches completados", "\(progress.completed)"),
                ("Rewatches pendientes", "\(stats.titlesRemaining)"),
                ("% del maratón", "\(Int(percent * 100))%"),
                ("Horas de rewatch", "\(hoursCompleted) h"),
                ("Horas restantes", "\(hoursRemaining) h"),
                ("Días hasta Doomsday", "\(stats.daysRemaining)"),
                ("Último rewatch", lastRewatch?.title ?? "Ninguno todavía"),
                ("Próximo rewatch", nextRewatch?.title ?? "¡Completado!"),
            ])
            .padding(.horizontal)
        }
    }

    private func grid(_ pairs: [(String, String)]) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(pairs, id: \.0) { pair in
                VStack(alignment: .leading, spacing: 4) {
                    Text(pair.1)
                        .font(.headline.weight(.bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    Text(pair.0)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}
