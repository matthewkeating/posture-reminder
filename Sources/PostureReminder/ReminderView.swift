import SwiftUI
import AppKit

struct ReminderView: View {
    @State private var opacity: Double = 0
    @State private var offsetY: CGFloat = 0

    var body: some View {
        ZStack {
            Color.clear
            Group {
                if let nsImage = NSImage(named: "arrow") {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                }
            }
            .frame(width: 100, height: 100)
            .offset(y: offsetY)
            .opacity(opacity)
        }
        .task {
            await animate()
        }
    }

    private func animate() async {
        // Phase 1: fade in (0.5s)
        withAnimation(.linear(duration: 0.5)) { opacity = 1 }

        // Sleep covers phase 1 (0.5s) + phase 2 stationary hold (0.25s)
        try? await Task.sleep(for: .seconds(0.75))

        // Phase 3: slide up 100 points (1.0s)
        withAnimation(.linear(duration: 1.0)) { offsetY = -100 }

        // Sleep covers phase 3 (1.0s)
        try? await Task.sleep(for: .seconds(1.0))

        // Phase 4: fade out (0.5s)
        withAnimation(.linear(duration: 0.5)) { opacity = 0 }
    }
}
