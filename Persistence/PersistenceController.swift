import Foundation
import SwiftData

/// Configura el ModelContainer local (sin servidor, sin login, 100% on-device).
enum PersistenceController {

    static let schema = Schema([MCUTitle.self])

    @MainActor
    static func makeContainer() -> ModelContainer {
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
        seedIfNeeded(container: container)
        return container
    }

    /// Solo siembra si la base está vacía (primer lanzamiento). El progreso
    /// (isSeenBefore / isRewatchedDoomsday) nunca se pisa en lanzamientos posteriores.
    @MainActor
    private static func seedIfNeeded(container: ModelContainer) {
        let context = container.mainContext
        let descriptor = FetchDescriptor<MCUTitle>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }

        for title in MCUDatabase.seedTitles() {
            context.insert(title)
        }
        try? context.save()
    }
}
