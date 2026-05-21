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
        if isFocusModeActive() {
            startTimer()
            return
        }
        ReminderWindowController.shared.showReminder()
        startTimer()
    }

    private func isFocusModeActive() -> Bool {
        let assertionsURL = FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/DoNotDisturb/DB/Assertions.json")

        guard
            let data = try? Data(contentsOf: assertionsURL),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let dataArray = json["data"] as? [[String: Any]],
            let first = dataArray.first,
            let records = first["storeAssertionRecords"] as? [[String: Any]]
        else {
            return false
        }

        return !records.isEmpty
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
