//
//  NotificationDetailDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//


import Foundation

public struct NotificationDetailDTO: Decodable {
    public let title: String
    public let createdAt: String
    public let createdAtUtc: String?
    public let content: String

    public init(title: String, createdAt: String, createdAtUtc: String?, content: String) {
        self.title = title
        self.createdAt = createdAt
        self.createdAtUtc = createdAtUtc
        self.content = content
    }
}
