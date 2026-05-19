import AppKit
import SwiftUI

final class IntervalWindowController: NSObject, NSWindowDelegate {
    static let shared = IntervalWindowController()

    private var window: NSWindow?

    func show(appState: AppState) {
        if let w = window {
            w.center()
            NSApp.activate()
            NSApp.runModal(for: w)
            return
        }

        let contentView = IntervalPickerView().environmentObject(appState)
        let hosting = NSHostingController(rootView: contentView)

        let w = NSWindow(contentViewController: hosting)
        w.title = "Set Interval"
        w.styleMask = [.titled, .closable]
        w.isReleasedWhenClosed = false
        w.delegate = self
        w.standardWindowButton(.miniaturizeButton)?.isHidden = true
        w.standardWindowButton(.zoomButton)?.isHidden = true
        w.center()

        window = w
        NSApp.activate()
        NSApp.runModal(for: w)
    }

    func hide() {
        NSApp.stopModal()
        window?.orderOut(nil)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        hide()
        return false
    }
}
