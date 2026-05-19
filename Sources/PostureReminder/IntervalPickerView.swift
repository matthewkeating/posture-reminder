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
                        .frame(width: 44)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: appState.interval) { newValue in
                            let clamped = min(max(newValue, 1), 480)
                            if clamped != newValue { appState.interval = clamped }
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
