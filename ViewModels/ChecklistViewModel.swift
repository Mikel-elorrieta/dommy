import Foundation
import SwiftData

enum StateFilter: String, CaseIterable, Identifiable {
    case all = "Todos"
    case notSeen = "⚪ No vistas"
    case seenBefore = "🟢 Vistas anteriormente"
    case rewatched = "🔥 Rewatch Doomsday"
    case pendingRewatch = "Pendientes de Rewatch"
    var id: String { rawValue }
}

enum TypeFilter: String, CaseIterable, Identifiable {
    case all = "Todos los tipos"
    case movies = "Películas"
    case series = "Series"
    var id: String { rawValue }
}

@MainActor
final class ChecklistViewModel: ObservableObject {
    @Published var stateFilter: StateFilter = .all
    @Published var typeFilter: TypeFilter = .all
    @Published var phaseFilter: MCUPhase? = nil
    @Published var searchText: String = ""

    func filtered(_ all: [MCUTitle], activeCategories: Set<ContentCategory>) -> [MCUTitle] {
        var result = all.filter { activeCategories.contains($0.category) || $0.category == .finalDestination }

        switch stateFilter {
        case .all: break
        case .notSeen: result = result.filter { $0.watchState == .notSeen }
        case .seenBefore: result = result.filter { $0.watchState == .seenBefore }
        case .rewatched: result = result.filter { $0.watchState == .rewatchedDoomsday }
        case .pendingRewatch: result = result.filter { $0.isSeenBefore && !$0.isRewatchedDoomsday }
        }

        switch typeFilter {
        case .all: break
        case .movies: result = result.filter { $0.mediaType == .movie }
        case .series: result = result.filter { $0.mediaType == .series }
        }

        if let phaseFilter {
            result = result.filter { $0.phase == phaseFilter }
        }

        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }

        return result.sorted { $0.releaseDate < $1.releaseDate }
    }
}
