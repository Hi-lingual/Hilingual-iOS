//
//  NotificationEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

public struct NotificationEntity: Equatable {
    public let id: Int
    public let title: String
    public let isRead: Bool
    public let publishedAt: String
    public let deeplink: String?
    public let type: NotificationType

    public init(
        id: Int,
        title: String,
        isRead: Bool,
        publishedAt: String,
        deeplink: String? = nil,
        type: NotificationType
    ) {
        self.id = id
        self.title = title
        self.isRead = isRead
        self.publishedAt = publishedAt
        self.deeplink = deeplink
        self.type = type
    }
}

public enum NotificationType: Equatable {
    case general(String)  // ex: "LIKE_DIARY", "FOLLOW_USER"
    case notice(String)   // ex: "NOTIFICATION", "MARKETING"
}
