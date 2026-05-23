import SwiftUI

@main
struct PostureReminderApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        MenuBarExtra {
            MenuBarContentView()
                .environmentObject(appState)
        } label: {
            Image(systemName: "arrow.up.circle")
        }
        .menuBarExtraStyle(.window)
    }
}
