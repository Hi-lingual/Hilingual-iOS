//
//  AlarmSettingEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

public struct AlarmSettingEntity {
    public let isMarketingAlarmOn: Bool
    public let isFeedAlarmOn: Bool

    public init(isMarketingAlarmOn: Bool, isFeedAlarmOn: Bool) {
        self.isMarketingAlarmOn = isMarketingAlarmOn
        self.isFeedAlarmOn = isFeedAlarmOn
    }
}
