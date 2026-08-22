//
//  WidgetDTO+Mapper.swift
//  HilingualData
//
//  Created by youngseo on 8/23/26.
//

import Foundation
import HilingualDomain
import HilingualNetwork

extension WidgetTopicResponseDTO {
    func toEntity() -> WidgetTopicEntity {
        WidgetTopicEntity(
            topicEn: topicEn,
            isWrittenToday: isWrittenToday
        )
    }
}

extension WidgetStreakResponseDTO {
    func toEntity() -> WidgetStreakEntity {
        WidgetStreakEntity(
            streak: streak,
            recentDays: recentDays.map { $0.toEntity() }
        )
    }
}

extension WidgetStreakRecentDayDTO {
    func toEntity() -> WidgetStreakRecentDayEntity {
        WidgetStreakRecentDayEntity(
            date: date,
            dayOfWeek: dayOfWeek,
            isWritten: isWritten
        )
    }
}
