//
//  NotificationModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import Foundation

public enum NotificationType {
    case feed
    case notice
}

public struct NotificationModel {
    public let id: Int
    public let type: NotificationType
    public let title: String
    public let isRead: Bool
    public let publishedAt: String 
    public let deeplink: String?
}

public struct NotificationListModel {
    var type: NotificationType
    var items: [NotificationModel]
}
