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

public final class MockNotificationService: NotificationService {

    public init() {}

    public func fetchGeneralNotifications() -> AnyPublisher<[GeneralNotificationDTO], Error> {
        let mockData: [GeneralNotificationDTO] = [
            GeneralNotificationDTO(
                notiId: 1,
                type: "LIKE_DIARY",
                title: "홍길동님이 당신의 일기에 공감했습니다.",
                deeplink: "Hilingual://notification/diarydetail?diaryId=1",
                isRead: false,
                publishedAt: "2025-08-04"
            ),
            GeneralNotificationDTO(
                notiId: 2,
                type: "FOLLOW_USER",
                title: "이몽룡님이 당신을 팔로우했습니다.",
                deeplink: "Hilingual://notification/feedprofile?userId=45",
                isRead: true,
                publishedAt: "2025-07-21"
            )
        ]

        return Just(mockData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func fetchNoticeNotifications() -> AnyPublisher<[NoticeNotificationDTO], Error> {
        let mockData: [NoticeNotificationDTO] = [
            NoticeNotificationDTO(
                notiId: 10,
                category: "NOTIFICATION",
                title: "v1.1.1 업데이트 알림",
                isRead: false,
                publishedAt: "2025-08-08"
            ),
            NoticeNotificationDTO(
                notiId: 11,
                category: "MARKETING",
                title: "매일 작성 이벤트에 참여해보세요!",
                isRead: true,
                publishedAt: "2025-08-08"
            )
        ]

        return Just(mockData)
            .setFailureType(to: Error.self)
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
            print("[Mock] 알림 읽음 처리 완료 → notiId: \(notiId)")
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
}
