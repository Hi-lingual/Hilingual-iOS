//
//  NotificationRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

import Combine

public protocol NotificationRepository {
    func fetchGeneralNotifications() -> AnyPublisher<[NotificationEntity], Error>
    func fetchNoticeNotifications() -> AnyPublisher<[NotificationEntity], Error>
    func fetchNotificationDetail(notiId: Int) -> AnyPublisher<NotificationDetailEntity, Error>
}
