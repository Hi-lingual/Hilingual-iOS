//
//  AppTimeZone.swift
//  HilingualCore
//
//  Created by 성현주 on 3/21/26.
//

import Foundation

public enum AppTimeZone {
    private final class Storage: @unchecked Sendable {
        private let lock = NSLock()
        private var identifier = TimeZone.current.identifier

        func currentIdentifier() -> String {
            lock.lock()
            defer { lock.unlock() }
            return identifier
        }

        func updateIdentifier(_ newIdentifier: String) {
            lock.lock()
            identifier = newIdentifier
            lock.unlock()
        }
    }

    private static let storage = Storage()

    public static var current: TimeZone {
        TimeZone(identifier: storage.currentIdentifier()) ?? .current
    }

    public static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = current
        return calendar
    }

    public static func configureCurrent() {
        storage.updateIdentifier(TimeZone.current.identifier)
    }

    public static func configure(identifier: String) {
        storage.updateIdentifier(identifier)
    }

    public static func formatter(
        _ format: String,
        locale: Locale = Locale(identifier: "ko_KR")
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = current
        formatter.dateFormat = format
        return formatter
    }
}
