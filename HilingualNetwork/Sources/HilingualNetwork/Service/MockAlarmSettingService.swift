//
//  MockAlarmSettingService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//

import Combine
import Foundation

public protocol AlarmSettingServiceProtocol {
    func fetchAlarmSetting() -> AnyPublisher<AlarmSettingDTO, Error>
    func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error>
}

public final class MockAlarmSettingService: AlarmSettingServiceProtocol {

    private var currentSetting = AlarmSettingDTO(marketing: true, feed: false)

    public init() {}

    public func fetchAlarmSetting() -> AnyPublisher<AlarmSettingDTO, Error> {
        return Just(currentSetting)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(300), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    public func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error> {
        currentSetting = AlarmSettingDTO(marketing: isMarketingOn, feed: isFeedOn)
        return Just(())
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(300), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
