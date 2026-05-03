//
//  NotificationDetailEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

public struct NotificationDetailEntity: Equatable {
    public let title: String
    public let createdAt: String
    public let createdAtUtc: String?
    public let content: String

    public init(title: String, createdAt: String, createdAtUtc: String? = nil, content: String) {
        self.title = title
        self.createdAt = createdAt
        self.createdAtUtc = createdAtUtc
        self.content = content
    }
}
