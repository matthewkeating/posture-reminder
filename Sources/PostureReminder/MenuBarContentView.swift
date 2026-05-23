import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        let minutes = Int(appState.timeRemaining) / 60
        let seconds = Int(appState.timeRemaining) % 60
        Text("Next reminder in \(minutes)m \(String(format: "%02d", seconds))s")
            .foregroundStyle(.secondary)

        Divider()

        Button("Show Reminder") {
            appState.triggerReminder()
        }

        Divider()

        Button("Set Interval") {
            IntervalWindowController.shared.show(appState: appState)
        }

        Divider()

        Button("View README (on GitHub)...") {
            if let url = URL(string: "https://github.com/matthewkeating/posture-reminder") {
                NSWorkspace.shared.open(url)
            }
        }

        Divider()

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
