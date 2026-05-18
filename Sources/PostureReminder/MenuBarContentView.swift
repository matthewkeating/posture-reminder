import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
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
