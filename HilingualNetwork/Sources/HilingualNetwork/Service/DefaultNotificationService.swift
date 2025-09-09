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
          return request(.getNotifications(tab: "feed"), as: BaseAPIResponse<[GeneralNotificationDTO]>.self)
              .map { $0.data }
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
      }

      public func fetchNoticeNotifications() -> AnyPublisher<[NoticeNotificationDTO], Error> {
          return request(.getNotifications(tab: "notice"), as: BaseAPIResponse<[NoticeNotificationDTO]>.self)
              .map { $0.data }
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
      }

    public func fetchNotificationDetail(notiId: Int) -> AnyPublisher<NotificationDetailDTO, Error> {
           let mock = NotificationDetailDTO(
               title: "v1.1.1 업데이트 알림",
               createdAt: "2025.08.08",
               content: """
               안녕하세요. 하이링구얼 입니다.

               하이링구얼 앱이 v.1.1.1 로 업데이트 되었습니다!

               [업데이트 내용]
               • 앱 안정화를 위한 관련 수정

               앱 최신 버전을 설치하여 새로워진 하이링구얼 앱을 사용해보세요.

               감사합니다.

               설치하러가기
               """
           )

           return Just(mock)
               .setFailureType(to: Error.self)
               .eraseToAnyPublisher()
       }

    public func markAsRead(notiId: Int) -> AnyPublisher<Void, Error> {
        return requestPlain(.markAsRead(id: notiId))
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
