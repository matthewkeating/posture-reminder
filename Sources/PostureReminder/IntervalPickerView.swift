import SwiftUI

struct IntervalPickerView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Reminder interval (minutes):")
                    .font(.headline)
                Spacer()
                HStack(spacing: 4) {
                    TextField("", value: $appState.interval, format: .number)
                        .frame(width: 35)
                        .multilineTextAlignment(.trailing)
                        .onSubmit {
                            appState.interval = min(max(appState.interval, 1), 60)
                        }
                }
            }

            HStack {
                Spacer()
                Button("Done") {
                    IntervalWindowController.shared.hide()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(width: 270)
    }
}
