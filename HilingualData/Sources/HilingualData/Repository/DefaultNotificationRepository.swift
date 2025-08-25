//
//  DefaultNotificationRepository.swift
//  HilingualData
//
//  Created by 성현주 on 8/26/25.
//

import Combine

import HilingualDomain
import HilingualNetwork


public final class DefaultNotificationRepository: NotificationRepository {

    private let service: NotificationService

    public init(service: NotificationService) {
        self.service = service
    }

    public func fetchGeneralNotifications() -> AnyPublisher<[NotificationEntity], Error> {
        return service.fetchGeneralNotifications()
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func fetchNoticeNotifications() -> AnyPublisher<[NotificationEntity], Error> {
        return service.fetchNoticeNotifications()
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func fetchNotificationDetail(notiId: Int) -> AnyPublisher<NotificationDetailEntity, Error> {
            return service.fetchNotificationDetail(notiId: notiId)
                .map { $0.toEntity() }
                .eraseToAnyPublisher()
        }
}
