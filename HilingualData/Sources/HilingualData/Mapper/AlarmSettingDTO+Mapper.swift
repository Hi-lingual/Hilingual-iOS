//
//  AlarmSettingDTO+Mapper.swift
//  HilingualData
//
//  Created by 성현주 on 8/26/25.
//


import HilingualDomain
import HilingualNetwork

extension NotificationSettingsResponseDTO {
    func toEntity() -> AlarmSettingEntity {
        return AlarmSettingEntity(
            isMarketingAlarmOn: marketing,
            isFeedAlarmOn: feed
        )
    }
}
