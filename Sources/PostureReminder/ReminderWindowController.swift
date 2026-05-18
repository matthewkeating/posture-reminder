import AppKit
import SwiftUI

final class ReminderWindowController {
    static let shared = ReminderWindowController()

    private var panels: [NSPanel] = []
    private var dismissTimer: Timer?

    func showReminder() {
        dismissTimer?.invalidate()
        dismissTimer = nil

        panels.forEach { $0.orderOut(nil) }
        panels.removeAll()

        for screen in NSScreen.screens {
            let panel = makePanel(for: screen)
            panels.append(panel)
            panel.orderFrontRegardless()
        }

        dismissTimer = Timer.scheduledTimer(withTimeInterval: 2.25, repeats: false) { [weak self] _ in
            self?.dismissAll()
        }
    }

    private func dismissAll() {
        panels.forEach { $0.orderOut(nil) }
        panels.removeAll()
        dismissTimer = nil
    }

    private func makePanel(for screen: NSScreen) -> NSPanel {
        // Full-screen panel so the 400-point upward slide isn't clipped.
        let panel = NSPanel(
            contentRect: screen.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.level = .screenSaver
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.hidesOnDeactivate = false

        let hostingView = NSHostingView(rootView: ReminderView())
        hostingView.frame = NSRect(origin: .zero, size: screen.frame.size)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor
        panel.contentView = hostingView

        return panel
    }
}
