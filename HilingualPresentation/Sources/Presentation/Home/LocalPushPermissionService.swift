import Foundation
import UserNotifications

public struct LocalPushPermissionService: Sendable {
    public init() {}
    
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
    
    public func isPermissionDenied() async -> Bool {
        await notificationAuthorizationStatus() == .denied
    }
}
