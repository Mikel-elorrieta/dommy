import SwiftUI
import SwiftData

struct ChecklistView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MCUTitle.releaseOrder) private var allTitles: [MCUTitle]
    @ObservedObject var roadmapViewModel: RoadmapViewModel
    @StateObject private var viewModel = ChecklistViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(StateFilter.allCases) { filter in
                            chip(filter.rawValue, isOn: viewModel.stateFilter == filter) {
                                viewModel.stateFilter = filter
                            }
                        }
                        Divider().frame(height: 20)
                        ForEach(TypeFilter.allCases) { filter in
                            chip(filter.rawValue, isOn: viewModel.typeFilter == filter) {
                                viewModel.typeFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                List {
                    ForEach(viewModel.filtered(allTitles, activeCategories: roadmapViewModel.activeCategories())) { item in
                        ChecklistRow(
                            item: item,
                            onMarkSeen: { roadmapViewModel.markSeenBefore(item, context: context) },
                            onMarkRewatch: { roadmapViewModel.markRewatch(item, context: context) }
                        )
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText, prompt: "Buscar título")
            }
            .navigationTitle("MCU Rewatch")
            .background(Color.black.ignoresSafeArea())
        }
        .preferredColorScheme(.dark)
    }

    // Chips con área táctil cómoda (~36-40pt de alto es aceptable para
    // controles secundarios en fila horizontal de scroll, no son la acción principal).
    private func chip(_ text: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(isOn ? Color.yellow : Color.white.opacity(0.08))
                .foregroundStyle(isOn ? .black : .white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

/// IMPORTANTE: el NavigationLink solo envuelve el poster + texto (zona de
/// navegación). El botón de acción rápida es un HERMANO fuera de su label,
/// nunca anidado dentro — un Button anidado en el label de un NavigationLink
/// no recibe su propio toque en SwiftUI (el toque siempre navega). Con
/// .buttonStyle(.borderless) en el botón secundario, List reconoce ambos
/// controles como interactivos de forma independiente.
private struct ChecklistRow: View {
    @Bindable var item: MCUTitle
    let onMarkSeen: () -> Void
    let onMarkRewatch: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            NavigationLink {
                TitleDetailView(title: item, onMarkSeen: onMarkSeen, onMarkRewatch: onMarkRewatch)
            } label: {
                HStack(spacing: 12) {
                    PosterView(title: item).frame(width: 50, height: 75)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title).font(.subheadline.weight(.semibold)).lineLimit(2)
                        HStack(spacing: 6) {
                            Text(String(item.releaseYear))
                            Text("·")
                            Text(item.phase.rawValue)
                            Text("·")
                            Text(item.runtimeFormatted)
                        }
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        stateLine
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer(minLength: 8)

            quickAction
        }
        .listRowBackground(Color.black)
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private var stateLine: some View {
        switch item.watchState {
        case .rewatchedDoomsday:
            Text("🔥 Rewatch Doomsday").font(.caption2.weight(.bold)).foregroundStyle(.orange)
        case .seenBefore:
            Text("🟢 Vista anteriormente").font(.caption2.weight(.bold)).foregroundStyle(.green)
        case .notSeen:
            Text(item.isReleased ? "⚪ No vista" : "🔒 Próximamente").font(.caption2).foregroundStyle(.secondary)
        }
    }

    // Todos los controles táctiles con área mínima de 44x44pt (Apple HIG),
    // aunque el elemento visual (icono/pill) sea más pequeño — el contentShape
    // + frame amplía la zona de toque sin cambiar el aspecto visual.
    @ViewBuilder
    private var quickAction: some View {
        if !item.isReleased {
            Image(systemName: "lock.fill")
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 44, height: 44)
        } else {
            switch item.watchState {
            case .rewatchedDoomsday:
                Image(systemName: "flame.circle.fill")
                    .font(.title)
                    .foregroundStyle(.orange)
                    .frame(width: 44, height: 44)
            case .seenBefore:
                Button(action: onMarkRewatch) {
                    Text("🔄 REWATCH")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.yellow)
                        .foregroundStyle(.black)
                        .clipShape(Capsule())
                }
                .buttonStyle(.borderless)
                .contentShape(Rectangle())
                .frame(minWidth: 44, minHeight: 44)
            case .notSeen:
                Button(action: onMarkSeen) {
                    Image(systemName: "circle")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.borderless)
                .contentShape(Rectangle())
                .frame(width: 44, height: 44)
            }
        }
    }
}
