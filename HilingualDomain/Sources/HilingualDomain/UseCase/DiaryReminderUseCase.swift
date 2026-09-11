//
//  DiaryReminderUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 9/5/26.
//

import Combine
import Foundation

public protocol DiaryReminderUseCase {
    func fetchReminderStatus() -> AnyPublisher<Bool, Never>
    func fetchReminderConfig() -> AnyPublisher<(hour: Int, minute: Int, weekdays: Set<Int>)?, Never>
    func saveReminder(hour: Int, minute: Int, weekdays: Set<Int>) -> AnyPublisher<Void, Error>
    func disableReminder()
    func refreshUpcomingReminders() -> AnyPublisher<Void, Error>
    func skipTodayReminderIfNeeded(for date: Date)
}

public final class DefaultDiaryReminderUseCase: DiaryReminderUseCase {

    private let repository: DiaryReminderRepository

    public init(repository: DiaryReminderRepository) {
        self.repository = repository
    }

    public func fetchReminderStatus() -> AnyPublisher<Bool, Never> {
        Just(repository.isReminderEnabled()).eraseToAnyPublisher()
    }

    public func saveReminder(hour: Int, minute: Int, weekdays: Set<Int>) -> AnyPublisher<Void, Error> {
        repository.scheduleReminder(hour: hour, minute: minute, weekdays: weekdays)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.repository.setReminderEnabled(true)
            })
            .eraseToAnyPublisher()
    }

    public func disableReminder() {
        repository.cancelReminder()
        repository.setReminderEnabled(false)
    }
    
    public func fetchReminderConfig() -> AnyPublisher<(hour: Int, minute: Int, weekdays: Set<Int>)?, Never> {
        Just(repository.fetchReminderConfig()).eraseToAnyPublisher()
    }
    
    public func refreshUpcomingReminders() -> AnyPublisher<Void, Error> {
        repository.refreshUpcomingReminders()
    }
    
    public func skipTodayReminderIfNeeded(for date: Date) {
        guard repository.isReminderEnabled() else { return }
        repository.skipTodayReminder(date: date)
    }
}
