//
//  AppVersionChecker.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 5/7/26.
//

import Foundation

enum AppVersionChecker {
    private static let key = "lastShownNotificationPermissionVersion"
    
    static var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static var shouldShowModal: Bool {
        let last = UserDefaults.standard.string(forKey: key) ?? ""
        return last != currentVersion
    }
    
    static func markAsShown() {
        UserDefaults.standard.set(currentVersion, forKey: key)
    }
}
