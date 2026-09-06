//
//  DiaryReminderRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 9/5/26.
//

import Combine

public protocol DiaryReminderRepository {
    func isReminderEnabled() -> Bool
    func setReminderEnabled(_ isEnabled: Bool)
    func fetchReminderConfig() -> (hour: Int, minute: Int, weekdays: Set<Int>)?
    func scheduleReminder(hour: Int, minute: Int, weekdays: Set<Int>) -> AnyPublisher<Void, Error>
    func cancelReminder()
}
