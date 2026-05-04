//
//  NotificationDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//

public struct GeneralNotificationDTO: Decodable {
    public let noticeId: Int
    public let type: String
    public let title: String
    public let targetId: Int
    public let isRead: Bool
    public let publishedAt: String
    public let publishedAtUtc: String?
}

public struct NoticeNotificationDTO: Decodable {
    public let noticeId: Int
    public let category: String
    public let title: String
    public let isRead: Bool
    public let publishedAt: String
    public let publishedAtUtc: String?
}
