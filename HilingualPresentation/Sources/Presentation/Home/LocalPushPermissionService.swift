import Foundation
import UserNotifications

struct LocalPushPermissionService: Sendable {
    func checkAndRequestPermission() async -> Bool {
        let status = await notificationAuthorizationStatus()

        switch status {
        case .notDetermined:
            return await requestAuthorization()
        case .authorized, .provisional:
            return true
        default:
            return false
        }
    }

    private func notificationAuthorizationStatus() async -> UNAuthorizationStatus {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let status = settings.authorizationStatus
                continuation.resume(returning: status)
            }
        }
    }

    private func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }
}
