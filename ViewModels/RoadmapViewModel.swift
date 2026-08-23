import Foundation
import SwiftData
import SwiftUI

@MainActor
final class RoadmapViewModel: ObservableObject {

    private enum DefaultsKey {
        static let mode = "com.mcurewatch.mode"
        static let multiverse = "com.mcurewatch.toggle.multiverse"
        static let defenders = "com.mcurewatch.toggle.defenders"
        static let agentCarter = "com.mcurewatch.toggle.agentCarter"
    }

    private let defaults: UserDefaults

    // Modo y toggles se persisten en UserDefaults en cuanto cambian (didSet),
    // y se restauran en init(). Así sobreviven a cerrar/reabrir la app,
    // igual que el progreso de cada título (que vive en SwiftData).
    @Published var mode: MaratonMode {
        didSet { defaults.set(mode.rawValue, forKey: DefaultsKey.mode) }
    }
    @Published var includeMultiverseToggle: Bool {
        didSet { defaults.set(includeMultiverseToggle, forKey: DefaultsKey.multiverse) }
    }
    @Published var includeDefendersToggle: Bool {
        didSet { defaults.set(includeDefendersToggle, forKey: DefaultsKey.defenders) }
    }
    @Published var includeAgentCarterToggle: Bool {
        didSet { defaults.set(includeAgentCarterToggle, forKey: DefaultsKey.agentCarter) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let storedMode = defaults.string(forKey: DefaultsKey.mode).flatMap { MaratonMode(rawValue: $0) }
        self.mode = storedMode ?? .roadToDoomsday
        self.includeMultiverseToggle = defaults.bool(forKey: DefaultsKey.multiverse)
        self.includeDefendersToggle = defaults.bool(forKey: DefaultsKey.defenders)
        self.includeAgentCarterToggle = defaults.bool(forKey: DefaultsKey.agentCarter)
    }

    /// Categorías activas según modo + toggles (sin incluir el nodo final,
    /// que se trata siempre aparte). ÚNICA fuente de verdad de "qué está activo":
    /// RoadToDoomsdayView, ChecklistView y StatsView llaman siempre a esta función
    /// (directa o indirectamente vía roadmapTitles/progress) para no divergir.
    func activeCategories() -> Set<ContentCategory> {
        switch mode {
        case .roadToDoomsday:
            return [.mcuCore, .multiverse]
        case .mcuCompleto:
            var set: Set<ContentCategory> = [.mcuCore]
            if includeMultiverseToggle { set.insert(.multiverse) }
            if includeDefendersToggle { set.insert(.defenders) }
            if includeAgentCarterToggle { set.insert(.agentCarter) }
            return set
        }
    }

    /// Título especial Avengers: Doomsday, siempre presente, nunca filtrado.
    func finalDestination(from all: [MCUTitle]) -> MCUTitle? {
        all.first { $0.category == .finalDestination }
    }

    /// Camino principal del roadmap: MCU núcleo primero, después el resto de
    /// categorías activas en orden de estreno dentro de cada una. El nodo final
    /// NUNCA se incluye aquí (se muestra aparte como tarjeta especial), así que
    /// nunca cuenta en el denominador de progress() ni en DoomsdayCalculator.
    func roadmapTitles(from all: [MCUTitle]) -> [MCUTitle] {
        let active = activeCategories()
        let core = all.filter { $0.category == .mcuCore }.sorted { $0.releaseOrder < $1.releaseOrder }
        var result = core
        for cat in [ContentCategory.multiverse, .defenders, .agentCarter] where active.contains(cat) {
            result += all.filter { $0.category == cat }.sorted { $0.releaseOrder < $1.releaseOrder }
        }
        return result
    }

    /// Siguiente parada: primer título activo, ya estrenado, cuyo
    /// isRewatchedDoomsday sea false. "Vista anteriormente" (🟢) NO se salta:
    /// solo isRewatchedDoomsday == true hace avanzar la posición.
    func nextStop(from all: [MCUTitle]) -> MCUTitle? {
        roadmapTitles(from: all).first { $0.isReleased && !$0.isRewatchedDoomsday }
    }

    func progress(for all: [MCUTitle]) -> (completed: Int, total: Int, percent: Double) {
        let items = roadmapTitles(from: all)
        let completed = items.filter { $0.isRewatchedDoomsday }.count
        let total = items.count
        let percent = total == 0 ? 0 : Double(completed) / Double(total)
        return (completed, total, percent)
    }

    // MARK: - Acciones de estado

    func markSeenBefore(_ title: MCUTitle, context: ModelContext) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            title.markSeenBefore()
        }
        try? context.save()
    }

    func markRewatch(_ title: MCUTitle, context: ModelContext) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
            title.markRewatchDoomsday()
        }
        try? context.save()
    }

    func unmarkSeen(_ title: MCUTitle, context: ModelContext) {
        withAnimation { title.unmarkSeenBefore() }
        try? context.save()
    }

    func unmarkRewatch(_ title: MCUTitle, context: ModelContext) {
        withAnimation { title.unmarkRewatch() }
        try? context.save()
    }
}
