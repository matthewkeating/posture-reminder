import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var interval: Int {
        didSet {
            UserDefaults.standard.set(interval, forKey: "reminderInterval")
            restartTimer()
        }
    }

    private var timer: Timer?

    init() {
        let saved = UserDefaults.standard.integer(forKey: "reminderInterval")
        self.interval = saved > 0 ? saved : 10
        startTimer()
    }

    func triggerReminder() {
        fireReminder()
    }

    private func fireReminder() {
        ReminderWindowController.shared.showReminder()
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        let t = Timer(timeInterval: TimeInterval(interval * 60), repeats: false) { [weak self] _ in
            self?.fireReminder()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func restartTimer() {
        startTimer()
    }
}
