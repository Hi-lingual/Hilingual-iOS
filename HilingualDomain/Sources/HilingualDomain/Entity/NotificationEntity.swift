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
    public let publishedAtUtc: String?
    public let targetId: Int?
    public let type: NotificationType

    public init(
        id: Int,
        title: String,
        isRead: Bool,
        publishedAt: String,
        publishedAtUtc: String? = nil,
        targetId: Int? = nil,
        type: NotificationType
    ) {
        self.id = id
        self.title = title
        self.isRead = isRead
        self.publishedAt = publishedAt
        self.publishedAtUtc = publishedAtUtc
        self.targetId = targetId
        self.type = type
    }
}

public enum NotificationType: Equatable {
    case general(String)
    case notice(String) 
}
