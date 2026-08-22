//
//  Date+.swift
//  HilingualWidget
//
//  Created by youngseo on 8/22/26.
//

import Foundation

extension Date {
    var widgetMonthDayWeekdayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 E"
        return formatter.string(from: self)
    }

    var widgetAPIDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    var widgetRemainingHoursInTwoDays: Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        let deadline = calendar.date(byAdding: .day, value: 2, to: startOfDay) ?? self
        let remainingSeconds = max(deadline.timeIntervalSince(self), 0)
        return Int(ceil(remainingSeconds / 3600))
    }

    var widgetNextRefreshDate: Date {
        let calendar = Calendar.current
        let nextHour = calendar.date(byAdding: .hour, value: 1, to: self) ?? self
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: self) ?? self
        let nextMidnight = calendar.startOfDay(for: tomorrow)
        return min(nextHour, nextMidnight)
    }
}
