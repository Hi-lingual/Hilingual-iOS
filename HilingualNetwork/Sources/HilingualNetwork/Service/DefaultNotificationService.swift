//
//  NotificationService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//

import Combine

public protocol NotificationService {
    func fetchGeneralNotifications() -> AnyPublisher<[GeneralNotificationDTO], Error>
    func fetchNoticeNotifications() -> AnyPublisher<[NoticeNotificationDTO], Error>
    func fetchNotificationDetail(notiId: Int) -> AnyPublisher<NotificationDetailDTO, Error>
    func markAsRead(notiId: Int) -> AnyPublisher<Void, Error>
}

public final class DefaultNotificationService: BaseService<NotificationAPI>, NotificationService {

    public init() {}

    public func fetchGeneralNotifications() -> AnyPublisher<[GeneralNotificationDTO], Error> {
          return request(.getNotifications(tab: "FEED"), as: BaseAPIResponse<[GeneralNotificationDTO]>.self)
              .map { $0.data }
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
      }

      public func fetchNoticeNotifications() -> AnyPublisher<[NoticeNotificationDTO], Error> {
          return request(.getNotifications(tab: "NOTIFICATION"), as: BaseAPIResponse<[NoticeNotificationDTO]>.self)
              .map { $0.data }
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
      }

    public func fetchNotificationDetail(notiId: Int) -> AnyPublisher<NotificationDetailDTO, Error> {
        return request(.getNotificationDetail(id: notiId), as: BaseAPIResponse<NotificationDetailDTO>.self)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func markAsRead(notiId: Int) -> AnyPublisher<Void, Error> {
        return requestPlain(.markAsRead(id: notiId))
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
