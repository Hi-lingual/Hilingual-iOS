//
//  DefaultDiaryReminderRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 9/5/26.
//

import Combine
import HilingualDomain

public final class DefaultDiaryReminderRepository: DiaryReminderRepository {

    private let localDataSource: DiaryReminderLocalDataSource

    public init(localDataSource: DiaryReminderLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func isReminderEnabled() -> Bool { localDataSource.isEnabled() }
    public func setReminderEnabled(_ isEnabled: Bool) { localDataSource.setEnabled(isEnabled) }

    public func scheduleReminder(hour: Int, minute: Int, weekdays: Set<Int>) -> AnyPublisher<Void, Error> {
        localDataSource.schedule(hour: hour, minute: minute, weekdays: weekdays)
    }

    public func cancelReminder() { localDataSource.cancel() }
    
    public func fetchReminderConfig() -> (hour: Int, minute: Int, weekdays: Set<Int>)? {
        localDataSource.fetchConfig()
    }
}
