import SwiftUI

struct IntervalPickerView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reminder interval")
                .font(.headline)

            Stepper(
                value: $appState.interval,
                in: 1...60
            ) {
                Text("\(appState.interval) minute\(appState.interval == 1 ? "" : "s")")
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
        .frame(width: 240)
    }
}
