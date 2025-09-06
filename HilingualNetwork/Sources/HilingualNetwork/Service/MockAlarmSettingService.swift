//
//  MockAlarmSettingService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//

import Combine
import Foundation

public protocol AlarmSettingServiceProtocol {
    func fetchAlarmSetting() -> AnyPublisher<NotificationSettingsResponseDTO, Error>
    func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error>
}

public final class MockAlarmSettingService: BaseService<NotificationAPI>,AlarmSettingServiceProtocol {

    private var currentSetting = NotificationSettingsResponseDTO(marketing: true, feed: false)

    public init() {}

    public func fetchAlarmSetting() -> AnyPublisher<NotificationSettingsResponseDTO, Error> {
        return request(.fetchNotificationSettings, as: BaseAPIResponse<NotificationSettingsResponseDTO>.self)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func updateAlarmSetting(isMarketingOn: Bool, isFeedOn: Bool) -> AnyPublisher<Void, Error> {
        currentSetting = NotificationSettingsResponseDTO(marketing: isMarketingOn, feed: isFeedOn)
        return Just(())
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(300), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
