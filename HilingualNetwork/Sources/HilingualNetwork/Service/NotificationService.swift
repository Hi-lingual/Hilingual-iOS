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
}

public final class MockNotificationService: NotificationService {

    public init() {}

    public func fetchGeneralNotifications() -> AnyPublisher<[GeneralNotificationDTO], Error> {
        let mockData: [GeneralNotificationDTO] = [
            GeneralNotificationDTO(
                notiId: 1,
                type: "LIKE_DIARY",
                title: "홍길동님이 당신의 일기에 공감했습니다.",
                deeplink: "myapp://diarydetail?id=1",
                isRead: false,
                publishedAt: "2025-08-04"
            ),
            GeneralNotificationDTO(
                notiId: 2,
                type: "FOLLOW_USER",
                title: "이몽룡님이 당신을 팔로우했습니다.",
                deeplink: "myapp://user/45?notif=2",
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
}
