import Foundation
import SwiftData

enum MediaType: String, Codable, CaseIterable {
    case movie = "Película"
    case series = "Serie"
    case special = "Especial"
}

/// Fase narrativa. Para bloques que no son MCU núcleo se usa un caso propio
/// (no forman parte de las Fases 1-6 oficiales) solo para poder filtrar/agrupar en UI.
enum MCUPhase: String, Codable, CaseIterable {
    case phase1 = "Fase 1"
    case phase2 = "Fase 2"
    case phase3 = "Fase 3"
    case phase4 = "Fase 4"
    case phase5 = "Fase 5"
    case phase6 = "Fase 6"
    case multiverse = "Multiverse"
    case defenders = "Defenders Saga"
    case agentCarter = "Agent Carter"

    var sortIndex: Int {
        switch self {
        case .phase1: return 0
        case .phase2: return 1
        case .phase3: return 2
        case .phase4: return 3
        case .phase5: return 4
        case .phase6: return 5
        case .multiverse: return 6
        case .defenders: return 7
        case .agentCarter: return 8
        }
    }
}

/// Bloque de contenido. Determina en qué modo(s) aparece el título y si depende
/// de un toggle de contenido opcional.
enum ContentCategory: String, Codable, CaseIterable {
    case mcuCore = "MCU Núcleo"
    case multiverse = "Multiverse"
    case defenders = "Defenders Saga"
    case agentCarter = "Agent Carter"
    case finalDestination = "Destino Final"
}

/// Modo de maratón. Determina qué categorías entran por defecto.
enum MaratonMode: String, CaseIterable, Identifiable {
    case roadToDoomsday = "Road to Doomsday"
    case mcuCompleto = "MCU Completo"
    var id: String { rawValue }
}

/// Los tres estados de progreso, independientes entre sí a nivel de dato
/// pero derivados aquí como conveniencia de lectura.
enum WatchState {
    case notSeen            // ⚪
    case seenBefore         // 🟢 vista anteriormente, pendiente de rewatch
    case rewatchedDoomsday  // 🔥 vista durante el maratón actual
}

@Model
final class MCUTitle {
    @Attribute(.unique) var id: String

    var title: String
    var releaseDate: Date
    var mediaTypeRaw: String
    var phaseRaw: String
    var categoryRaw: String
    var runtimeMinutes: Int
    var releaseOrder: Int
    var posterAssetName: String

    // MARK: - Estados independientes (persistidos por separado, nunca se pisan entre sí)
    var isSeenBefore: Bool
    var seenBeforeDate: Date?
    var isRewatchedDoomsday: Bool
    var rewatchDate: Date?

    init(
        id: String,
        title: String,
        releaseDate: Date,
        mediaType: MediaType,
        phase: MCUPhase,
        category: ContentCategory,
        runtimeMinutes: Int,
        releaseOrder: Int,
        posterAssetName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.mediaTypeRaw = mediaType.rawValue
        self.phaseRaw = phase.rawValue
        self.categoryRaw = category.rawValue
        self.runtimeMinutes = runtimeMinutes
        self.releaseOrder = releaseOrder
        self.posterAssetName = posterAssetName ?? id
        self.isSeenBefore = false
        self.seenBeforeDate = nil
        self.isRewatchedDoomsday = false
        self.rewatchDate = nil
    }

    var mediaType: MediaType { MediaType(rawValue: mediaTypeRaw) ?? .movie }
    var phase: MCUPhase { MCUPhase(rawValue: phaseRaw) ?? .phase1 }
    var category: ContentCategory { ContentCategory(rawValue: categoryRaw) ?? .mcuCore }

    var releaseYear: Int { Calendar.current.component(.year, from: releaseDate) }

    var runtimeFormatted: String {
        let h = runtimeMinutes / 60
        let m = runtimeMinutes % 60
        if h == 0 { return "\(m) min" }
        return m == 0 ? "\(h) h" : "\(h) h \(m) min"
    }

    /// Ya se estrenó (independiente de si lo has visto o no).
    var isReleased: Bool { releaseDate <= Date() }

    var isFinalDestination: Bool { category == .finalDestination }

    var watchState: WatchState {
        if isRewatchedDoomsday { return .rewatchedDoomsday }
        if isSeenBefore { return .seenBefore }
        return .notSeen
    }

    /// Acción "✓ Ya la he visto" — marca visto anteriormente SIN tocar el rewatch.
    func markSeenBefore() {
        isSeenBefore = true
        if seenBeforeDate == nil { seenBeforeDate = Date() }
    }

    /// Acción "🔄 Rewatch Doomsday" — marca el rewatch y, si hiciera falta,
    /// también marca "vista anteriormente" automáticamente (nunca puede haber
    /// rewatch sin visto=true).
    func markRewatchDoomsday() {
        isSeenBefore = true
        if seenBeforeDate == nil { seenBeforeDate = Date() }
        isRewatchedDoomsday = true
        rewatchDate = Date()
    }

    /// Desmarca "vista anteriormente". Si no se ha visto, tampoco puede
    /// contar como rewatch, así que ambos estados se resetean en cascada.
    func unmarkSeenBefore() {
        isSeenBefore = false
        seenBeforeDate = nil
        isRewatchedDoomsday = false
        rewatchDate = nil
    }

    /// Desmarca solo el rewatch, conservando el "vista anteriormente".
    func unmarkRewatch() {
        isRewatchedDoomsday = false
        rewatchDate = nil
    }
}
