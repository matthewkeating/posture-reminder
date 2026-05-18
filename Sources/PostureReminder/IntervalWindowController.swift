import AppKit
import SwiftUI

final class IntervalWindowController: NSObject {
    static let shared = IntervalWindowController()

    private var window: NSWindow?

    func show(appState: AppState) {
        if let w = window {
            w.makeKeyAndOrderFront(nil)
            NSApp.activate()
            return
        }

        let contentView = IntervalPickerView().environmentObject(appState)
        let hosting = NSHostingController(rootView: contentView)

        let w = NSWindow(contentViewController: hosting)
        w.title = "Set Interval"
        w.styleMask = [.titled, .closable]
        w.isReleasedWhenClosed = false
        w.level = .floating

        if let screen = NSScreen.main {
            let size = NSSize(width: 270, height: 130)
            let origin = NSPoint(
                x: screen.visibleFrame.maxX - size.width - 16,
                y: screen.visibleFrame.maxY - size.height - 8
            )
            w.setFrame(NSRect(origin: origin, size: size), display: true)
        }

        w.makeKeyAndOrderFront(nil)
        NSApp.activate()
        window = w
    }

    func hide() {
        window?.orderOut(nil)
    }
}
