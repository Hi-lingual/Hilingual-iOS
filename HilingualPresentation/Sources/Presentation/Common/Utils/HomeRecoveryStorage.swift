//
//  HomeRecoveryStorage.swift
//  HilingualPresentation
//
//  Created by 조영서 on 6/20/26.
//

import Foundation

enum HomeRecoveryStorage {
    private static let recoveredDateKeysKey = "home.recoveredDateKeys"
    private static let dismissedRecoveryModalMonthKey = "home.dismissedRecoveryModalMonth"
    private static let currentUserNicknameKey = "currentUser.nickname"

    static func removeRecoveredDateKey(_ dateKey: String) {
        var dateKeys = Set(UserDefaults.standard.stringArray(forKey: recoveredDateKeysKey) ?? [])
        dateKeys.remove(dateKey)
        UserDefaults.standard.set(Array(dateKeys), forKey: recoveredDateKeysKey)
    }

    static func clearSessionCache() {
        UserDefaults.standard.removeObject(forKey: recoveredDateKeysKey)
        UserDefaults.standard.removeObject(forKey: dismissedRecoveryModalMonthKey)
        UserDefaults.standard.removeObject(forKey: currentUserNicknameKey)
    }
}
