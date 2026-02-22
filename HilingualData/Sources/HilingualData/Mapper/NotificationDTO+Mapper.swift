//
//  NotificationDTO+Mapper.swift
//  HilingualData
//
//  Created by 성현주 on 8/26/25.
//

import Foundation

import HilingualDomain
import HilingualNetwork

extension GeneralNotificationDTO {
    func toEntity() -> NotificationEntity {
        return NotificationEntity(
            id: noticeId,
            title: title,
            isRead: isRead,
            publishedAt: publishedAt,
            targetId: targetId,
            type: .general(type)
        )
    }
}

extension NoticeNotificationDTO {
    func toEntity() -> NotificationEntity {
        return NotificationEntity(
            id: noticeId,
            title: title,
            isRead: isRead,
            publishedAt: publishedAt,
            targetId: nil,
            type: .notice(category)
        )
    }
}
