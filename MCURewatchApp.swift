import SwiftUI
import SwiftData

@main
struct MCURewatchApp: App {
    let container = PersistenceController.makeContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
