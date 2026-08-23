import SwiftUI
import SwiftData
import UIKit

struct RoadToDoomsdayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MCUTitle.releaseOrder) private var allTitles: [MCUTitle]
    @ObservedObject var viewModel: RoadmapViewModel
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    modePicker

                    if viewModel.mode == .mcuCompleto {
                        contentToggles
                    }

                    countdownHeader

                    nextStopCard

                    let progress = viewModel.progress(for: allTitles)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.mode == .roadToDoomsday ? "ROAD TO DOOMSDAY" : "MCU COMPLETO")
                            .font(.title3.weight(.heavy))
                        ProgressBarView(completed: progress.completed, total: progress.total, percent: progress.percent)
                    }
                    .padding(.horizontal)

                    LazyVStack(spacing: 4) {
                        ForEach(viewModel.roadmapTitles(from: allTitles)) { item in
                            RoadmapNodeView(
                                title: item,
                                isNext: item.id == viewModel.nextStop(from: allTitles)?.id,
                                onMarkSeen: { viewModel.markSeenBefore(item, context: context) },
                                onMarkRewatch: { viewModel.markRewatch(item, context: context) },
                                onUnmarkSeen: { viewModel.unmarkSeen(item, context: context) },
                                onUnmarkRewatch: { viewModel.unmarkRewatch(item, context: context) }
                            )
                        }
                    }
                    .padding(.horizontal)

                    FinalDestinationCardView(
                        title: viewModel.finalDestination(from: allTitles),
                        activeTitles: viewModel.roadmapTitles(from: allTitles),
                        completed: progress.completed,
                        total: progress.total
                    )
                    .padding(.top, 12)

                    Button {
                        generateAndShareImage()
                    } label: {
                        Label("Generar imagen del roadmap", systemImage: "square.and.arrow.up")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top, 8)
            }
            .background(Color.black.ignoresSafeArea())
            .foregroundStyle(.white)
            .navigationTitle("")
            .sheet(isPresented: $showShareSheet) {
                if let shareImage {
                    ShareSheet(items: [shareImage])
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var modePicker: some View {
        Picker("Modo", selection: $viewModel.mode) {
            ForEach(MaratonMode.allCases) { mode in
                Text(mode == .roadToDoomsday ? "🔥 Road to Doomsday" : "🏆 MCU Completo").tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    private var contentToggles: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CONTENIDO OPCIONAL")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
            Toggle("Multiverse / X-Men (12 títulos)", isOn: $viewModel.includeMultiverseToggle)
            Toggle("Defenders Saga — Netflix (13 títulos)", isOn: $viewModel.includeDefendersToggle)
            Toggle("Agent Carter (2 títulos)", isOn: $viewModel.includeAgentCarterToggle)
        }
        .toggleStyle(.switch)
        .tint(.yellow)
        .font(.subheadline)
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
    }

    private var countdownHeader: some View {
        let stats = DoomsdayCalculator.stats(for: viewModel.roadmapTitles(from: allTitles))
        return VStack(spacing: 10) {
            Text("🚀 ROAD TO DOOMSDAY")
                .font(.headline.weight(.heavy))
                .foregroundStyle(.yellow)
            HStack(spacing: 18) {
                statBlock(value: "\(stats.daysRemaining)", label: "días restantes")
                statBlock(value: "\(stats.titlesRemaining)", label: "títulos restantes")
            }
            HStack(spacing: 18) {
                statBlock(value: String(format: "%.1f", stats.titlesPerWeekNeeded), label: "títulos / semana")
                statBlock(value: formattedHours(stats.hoursPerWeekNeeded), label: "por semana")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: [Color.red.opacity(0.25), Color.black], startPoint: .top, endPoint: .bottom))
    }

    private func statBlock(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title2.weight(.bold))
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func formattedHours(_ hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        return "\(h)h \(m)min"
    }

    private var nextStopCard: some View {
        Group {
            if let next = viewModel.nextStop(from: allTitles) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("SIGUIENTE PARADA")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                    HStack(spacing: 14) {
                        PosterView(title: next).frame(width: 56, height: 84)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🎬 \(next.title)")
                                .font(.headline)
                            Text("\(next.releaseYear) · \(next.phase.rawValue)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if next.isSeenBefore {
                                Text("🟢 Ya la habías visto antes")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(.green)
                            }
                        }
                        Spacer()
                    }
                    Button {
                        viewModel.markRewatch(next, context: context)
                    } label: {
                        Text("🔄 REWATCH DOOMSDAY")
                            .font(.subheadline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.yellow)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
            }
        }
    }

    @MainActor
    private func generateAndShareImage() {
        let posterView = RoadmapPosterExportView(
            titles: viewModel.roadmapTitles(from: allTitles),
            progress: viewModel.progress(for: allTitles),
            modeTitle: viewModel.mode == .roadToDoomsday ? "ROAD TO DOOMSDAY" : "MCU COMPLETO"
        )
        if let image = RoadmapImageGenerator.render(posterView) {
            shareImage = image
            showShareSheet = true
        }
    }
}

private struct RoadmapPosterExportView: View {
    let titles: [MCUTitle]
    let progress: (completed: Int, total: Int, percent: Double)
    let modeTitle: String

    var body: some View {
        VStack(spacing: 18) {
            Text(modeTitle).font(.system(size: 32, weight: .heavy))
            Text("\(progress.completed) / \(progress.total) completados")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.yellow)
            ForEach(titles) { item in
                HStack(spacing: 12) {
                    PosterView(title: item).frame(width: 44, height: 66)
                    Text(item.title)
                        .font(.system(size: 15, weight: .medium))
                        .lineLimit(2)
                    Spacer()
                    if item.isRewatchedDoomsday {
                        Image(systemName: "flame.circle.fill").foregroundStyle(.orange).font(.title3)
                    } else if item.isSeenBefore {
                        Image(systemName: "eye.circle.fill").foregroundStyle(.green).font(.title3)
                    }
                }
            }
            Text("💥 AVENGERS: DOOMSDAY")
                .font(.system(size: 26, weight: .heavy))
                .padding(.top, 8)
        }
        .padding(28)
        .frame(width: 560)
        .background(Color.black)
        .foregroundStyle(.white)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
