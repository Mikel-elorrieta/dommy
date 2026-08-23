import SwiftUI

struct ContentView: View {
    @StateObject private var roadmapViewModel = RoadmapViewModel()

    var body: some View {
        TabView {
            RoadToDoomsdayView(viewModel: roadmapViewModel)
                .tabItem { Label("Road to Doomsday", systemImage: "star.fill") }

            ChecklistView(roadmapViewModel: roadmapViewModel)
                .tabItem { Label("Lista completa", systemImage: "checklist") }

            StatsView(roadmapViewModel: roadmapViewModel)
                .tabItem { Label("Mi Maratón", systemImage: "chart.bar.fill") }
        }
        .tint(.yellow)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .modelContainer(PersistenceController.makeContainer())
}
