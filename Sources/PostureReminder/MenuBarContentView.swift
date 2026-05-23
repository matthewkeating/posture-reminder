import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                let remaining = max(0, appState.timerFireDate.timeIntervalSince(context.date))
                let minutes = Int(remaining) / 60
                let seconds = Int(remaining) % 60
                Text("Next reminder in \(minutes)m \(String(format: "%02d", seconds))s")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }

            Divider()

            MenuButton("Show Reminder") { appState.triggerReminder() }

            Divider()

            MenuButton("Set Interval") {
                IntervalWindowController.shared.show(appState: appState)
            }

            Divider()

            MenuButton("View README (on GitHub)...") {
                if let url = URL(string: "https://github.com/matthewkeating/posture-reminder") {
                    NSWorkspace.shared.open(url)
                }
            }

            Divider()

            MenuButton("Quit") { NSApplication.shared.terminate(nil) }
        }
        .frame(width: 220)
    }
}

private struct MenuButton: View {
    let title: String
    let action: () -> Void
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    private var labelColor: Color {
        colorScheme == .dark
            ? Color(red: 219/255, green: 219/255, blue: 219/255)
            : Color(red: 37/255, green: 37/255, blue: 37/255)
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isHovered ? Color.accentColor : Color.clear)
                .foregroundStyle(isHovered ? Color.white : labelColor)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
