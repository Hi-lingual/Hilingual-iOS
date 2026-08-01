//
//  HomeModalPolicy.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/1/26.
//

import Foundation

struct HomeModalContext {
    let today: Date
    let selectedDate: Date
    let recoveryTickets: Int
    let didLoadFilledDates: Bool
    let filledDates: [Date]
    let recoveredDates: [Date]
    let isAlreadyDismissedThisMonth: Bool
    let isTemporarilyDismissedThisMonth: Bool
}

enum HomeModalPolicy {
    case notificationPermission
    case recoveryStreak(Date)

    static func evaluate(context: HomeModalContext, isNotificationPermissionModalShown: Bool) -> HomeModalPolicy? {
        if !isNotificationPermissionModalShown {
            return .notificationPermission
        }

        let calendar = Calendar.current
        let lastDay = calendar.range(of: .day, in: .month, for: context.today)?.count ?? 31

        let canShowRecovery = context.didLoadFilledDates
            && context.recoveryTickets > 0
            && calendar.isDate(context.selectedDate, equalTo: context.today, toGranularity: .month)
            && !context.isAlreadyDismissedThisMonth
            && !context.isTemporarilyDismissedThisMonth
            && calendar.component(.day, from: context.today) >= lastDay - 7

        if canShowRecovery, let missedDate = fetchRecoveryDate(context: context) {
            return .recoveryStreak(missedDate)
        }

        return nil
    }

    private static func fetchRecoveryDate(context: HomeModalContext) -> Date? {
        let calendar = Calendar.current
        let filledKeys = Set(context.filledDates.map { $0.toFormattedString("yyyy-MM-dd") })
        let recoveredKeys = Set(context.recoveredDates.map { $0.toFormattedString("yyyy-MM-dd") })
        var date = calendar.date(byAdding: .day, value: -2, to: context.today)

        while let candidate = date,
              calendar.isDate(candidate, equalTo: context.today, toGranularity: .month) {
            let key = candidate.toFormattedString("yyyy-MM-dd")
            if !filledKeys.contains(key), !recoveredKeys.contains(key) {
                return candidate
            }
            date = calendar.date(byAdding: .day, value: -1, to: candidate)
        }
        return nil
    }
}
