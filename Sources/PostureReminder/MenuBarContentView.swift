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
                    .padding(.leading, 16.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 5)
            }

            Divider()
                .padding(.horizontal, 16)
                .padding(.vertical, 5)

            MenuButton("Show Reminder") { appState.triggerReminder() }
            MenuButton("Pause Reminder") { appState.triggerReminder() }

            Divider()
                .padding(.horizontal, 16)
                .padding(.vertical, 5)

            MenuButton("Set Interval") {
                IntervalWindowController.shared.show(appState: appState)
            }

            Divider()
                .padding(.horizontal, 16)
                .padding(.vertical, 5)

            MenuButton("View README (on GitHub)...") {
                if let url = URL(string: "https://github.com/matthewkeating/posture-reminder") {
                    NSWorkspace.shared.open(url)
                }
            }

            Divider()
                .padding(.horizontal, 16)
                .padding(.vertical, 5)

            MenuButton("Quit", systemImage: "xmark.square") { NSApplication.shared.terminate(nil) }
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
        .frame(width: 220)
    }
}

private struct MenuButton: View {
    let title: String
    let systemImage: String?
    let action: () -> Void
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme

    init(_ title: String, systemImage: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    private var labelColor: Color {
        colorScheme == .dark
            ? Color(red: 219/255, green: 219/255, blue: 219/255)
            : Color(red: 37/255, green: 37/255, blue: 37/255)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .resizable()
                        .fontWeight(.semibold)
                        .frame(width: 12, height: 10)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16.5)
            .padding(.trailing, 12)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isHovered ? Color.accentColor : Color.clear)
                    .frame(height: 24)
                    .padding(.horizontal, 5)
            )
            .foregroundStyle(isHovered ? Color.white : labelColor)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
