//
//  NotificationDetailDTO+Mapper.swift
//  HilingualData
//
//  Created by 성현주 on 8/26/25.
//

import HilingualDomain
import HilingualNetwork

extension NotificationDetailDTO {
    func toEntity() -> NotificationDetailEntity {
        return NotificationDetailEntity(
            title: title,
            createdAt: createdAt,
            createdAtUtc: createdAtUtc,
            content: content
        )
    }
}
