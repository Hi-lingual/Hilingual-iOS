//
//  NotificationUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

import Combine

public protocol NotificationUseCase {
    func fetchFeedNotifications() -> AnyPublisher<[NotificationEntity], Error>
    func fetchNoticeNotifications() -> AnyPublisher<[NotificationEntity], Error>
}

public final class DefaultNotificationUseCase: NotificationUseCase {

    private let repository: NotificationRepository

    public init(repository: NotificationRepository) {
        self.repository = repository
    }

    public func fetchFeedNotifications() -> AnyPublisher<[NotificationEntity], Error> {
        return repository.fetchGeneralNotifications()
    }

    public func fetchNoticeNotifications() -> AnyPublisher<[NotificationEntity], Error> {
        return repository.fetchNoticeNotifications()
    }
}
