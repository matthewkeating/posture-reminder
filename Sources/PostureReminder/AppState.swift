import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var interval: Int {
        didSet {
            UserDefaults.standard.set(interval, forKey: "reminderInterval")
            startTimer()
        }
    }

    @Published private(set) var timeRemaining: TimeInterval = 0
    private var timer: Timer?
    private var displayTimer: Timer?

    init() {
        let saved = UserDefaults.standard.integer(forKey: "reminderInterval")
        self.interval = saved > 0 ? saved : 10
        startTimer()
    }

    func triggerReminder() {
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
        displayTimer?.invalidate()
        timeRemaining = TimeInterval(interval * 60)

        let t = Timer(timeInterval: TimeInterval(interval * 60), repeats: false) { [weak self] _ in
            self?.triggerReminder()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t

        let d = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeRemaining = max(0, self.timer?.fireDate.timeIntervalSinceNow ?? 0)
        }
        RunLoop.main.add(d, forMode: .common)
        displayTimer = d
    }

}
