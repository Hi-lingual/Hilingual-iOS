//
//  LocalPushRepositoryImpl.swift
//  HilingualData
//
//  Created by 성현주 on 12/21/25.
//


import Foundation
import HilingualDomain

import UserNotifications

//TODO: - 인프라 모듈로 이관
public final class DefaultLocalPushRepository: LocalPushRepository {
    private let userDefaults = UserDefaults.standard
    private let scheduledKey = "is_local_push_scheduled"

    public init() {}

    public func isScheduled() -> Bool {
        return userDefaults.bool(forKey: scheduledKey)
    }

    public func saveScheduledStatus(_ scheduled: Bool) {
        userDefaults.set(scheduled, forKey: scheduledKey)
    }

    public func registerNotification(id: String, title: String, body: String, weekday: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["url": "hilingual://notification/home"]

        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[LocalPush] 등록 실패: \(id), \(error.localizedDescription)")
            }
        }
    }
}
