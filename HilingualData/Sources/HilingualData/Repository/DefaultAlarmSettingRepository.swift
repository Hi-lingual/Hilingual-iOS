//
//  DefaultAlarmSettingRepository.swift
//  HilingualData
//
//  Created by 성현주 on 8/26/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultAlarmSettingRepository: AlarmSettingRepository {

    private let service: AlarmSettingServiceProtocol

    public init(service: AlarmSettingServiceProtocol) {
        self.service = service
    }

    public func fetchAlarmSetting() -> AnyPublisher<AlarmSettingEntity, Error> {
        return service.fetchAlarmSetting()
            .map { $0.toEntity() }
            .eraseToAnyPublisher()
    }

    public func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error> {
        return service.updateAlarmSetting(isMarketingOn: isMarketingOn, isFeedOn: isFeedOn)
    }
}
