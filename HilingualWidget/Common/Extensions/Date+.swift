//
//  Date+.swift
//  HilingualWidget
//
//  Created by youngseo on 8/22/26.
//

import Foundation

extension Date {
    var widgetMonthDayWeekdayText: String {
        formatted(
            .verbatim(
                "\(month: .defaultDigits)월 \(day: .defaultDigits)일 \(weekday: .abbreviated)" as Date.FormatString,
                locale: Locale(identifier: "ko_KR"),
                timeZone: .current,
                calendar: .current
            )
        )
    }

    var widgetAPIDateText: String {
        ISO8601Format(
            Date.ISO8601FormatStyle(
                dateSeparator: .dash,
                dateTimeSeparator: .standard,
                timeZone: .current
            )
            .year()
            .month()
            .day()
        )
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
