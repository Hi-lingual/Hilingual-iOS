//
//  MockAlarmSettingService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//

import Combine
import Foundation

public protocol NotificationSettingService {
    func fetchAlarmSetting() -> AnyPublisher<NotificationSettingsResponseDTO, Error>
    func toggleNotificationSetting(notiType: String) -> AnyPublisher<Void, Error>
}

public final class DefaultNotificationSettingService: BaseService<NotificationAPI>,NotificationSettingService {

    private var currentSetting = NotificationSettingsResponseDTO(marketing: true, feed: false)

    public init() {}

    public func fetchAlarmSetting() -> AnyPublisher<NotificationSettingsResponseDTO, Error> {
        return request(.fetchNotificationSettings, as: BaseAPIResponse<NotificationSettingsResponseDTO>.self)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func toggleNotificationSetting(notiType: String) -> AnyPublisher<Void, Error> {
        request(.toggleNotificationSetting(notiType: notiType), as: BaseAPIResponse<NotificationSettingsResponseDTO>.self)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
