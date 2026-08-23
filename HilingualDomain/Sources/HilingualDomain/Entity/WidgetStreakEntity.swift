//
//  WidgetStreakEntity.swift
//  HilingualDomain
//
//  Created by youngseo on 8/23/26.
//

import Foundation

public struct WidgetStreakEntity {
    public let streak: Int
    public let recentDays: [WidgetStreakRecentDayEntity]

    public init(streak: Int, recentDays: [WidgetStreakRecentDayEntity]) {
        self.streak = streak
        self.recentDays = recentDays
    }
}

public struct WidgetStreakRecentDayEntity {
    public let date: String
    public let dayOfWeek: String
    public let isWritten: Bool

    public init(date: String, dayOfWeek: String, isWritten: Bool) {
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.isWritten = isWritten
    }
}
