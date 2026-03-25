import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorizationIfNeeded() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .notDetermined else { return }

        do {
            _ = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print(error.localizedDescription)
        }
    }

    func scheduleNotification(for payment: Payment) {
        guard payment.isNotificationEnabled, !payment.isClosed else {
            removeNotification(id: payment.id)
            return
        }

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = payment.title
        content.body = payment.type == .mounthly
            ? "Bugun odeme gunu."
            : "Odeme tarihi yaklasti."
        content.sound = .default

        guard let trigger = notificationTrigger(for: payment) else {
            return
        }

        let request = UNNotificationRequest(
            identifier: payment.id,
            content: content,
            trigger: trigger
        )

        center.removePendingNotificationRequests(withIdentifiers: [payment.id])
        center.add(request) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }

    func removeNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }

    private func notificationTrigger(for payment: Payment) -> UNNotificationTrigger? {
        let calendar = Calendar.current

        switch payment.type {
        case .mounthly:
            let dueDay = payment.dueDay ?? Date.fromISO8601(payment.dueDate)?.dayNumber ?? 1
            var components = DateComponents()
            components.calendar = calendar
            components.day = dueDay
            components.hour = 9
            components.minute = 0
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .oneTime:
            guard let dueDate = Date.fromISO8601(payment.dueDate) else { return nil }
            let notificationDate = calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: dueDate
            ) ?? dueDate

            guard notificationDate > .now else { return nil }

            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        }
    }
}
