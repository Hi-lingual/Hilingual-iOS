//
//  NotificationDetailEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

public struct NotificationDetailEntity: Equatable {
    public let title: String
    public let createdAt: String
    public let content: String

    public init(title: String, createdAt: String, content: String) {
        self.title = title
        self.createdAt = createdAt
        self.content = content
    }
}
