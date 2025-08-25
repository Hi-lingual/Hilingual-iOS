//
//  AlarmSettingUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/26/25.
//

import Combine

public protocol AlarmSettingUseCase {
    func fetchAlarmSetting() -> AnyPublisher<AlarmSettingEntity, Error>
    func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error>
}

public final class DefaultAlarmSettingUseCase: AlarmSettingUseCase {
    private let repository: AlarmSettingRepository

    public init(repository: AlarmSettingRepository) {
        self.repository = repository
    }

    public func fetchAlarmSetting() -> AnyPublisher<AlarmSettingEntity, Error> {
        return repository.fetchAlarmSetting()
    }

    public func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error> {
        return repository.updateAlarmSetting(isMarketingOn: isMarketingOn, isFeedOn: isFeedOn)
    }
}
