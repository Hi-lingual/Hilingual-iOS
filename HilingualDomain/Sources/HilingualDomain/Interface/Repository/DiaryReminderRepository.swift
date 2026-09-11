//
//  DiaryReminderRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 9/5/26.
//

import Combine
import Foundation

public protocol DiaryReminderRepository {
    func isReminderEnabled() -> Bool
    func setReminderEnabled(_ isEnabled: Bool)
    func fetchReminderConfig() -> (hour: Int, minute: Int, weekdays: Set<Int>)?
    func scheduleReminder(hour: Int, minute: Int, weekdays: Set<Int>) -> AnyPublisher<Void, Error>
    func refreshUpcomingReminders() -> AnyPublisher<Void, Error>
    func skipTodayReminder(date: Date)
    func cancelReminder()
}
