//
//  AlarmSettingRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

import Combine

public protocol AlarmSettingRepository {
    func fetchAlarmSetting() -> AnyPublisher<AlarmSettingEntity, Error>
    func toggleNotificationSetting(notiType: String) -> AnyPublisher<Void, Error>
}
