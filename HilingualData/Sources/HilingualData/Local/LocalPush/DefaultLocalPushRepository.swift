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
    
    public func cancelNotifications(ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    public func clearLegacyScheduledFlag() {
        userDefaults.removeObject(forKey: scheduledKey)
    }
}
