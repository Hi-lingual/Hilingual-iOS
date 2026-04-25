//
//  DefaultDeviceService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 3/21/26.
//

import Combine
import Foundation

public protocol DeviceService {
    func updateCurrentDevice() -> AnyPublisher<Void, Error>
}

public final class DefaultDeviceService: BaseService<DeviceAPI>, DeviceService {
    public init() {}

    public func updateCurrentDevice() -> AnyPublisher<Void, Error> {
        let deviceInfo = CurrentDeviceInfo.make()
        let requestDTO = DeviceRequestDTO(
            timezone: deviceInfo.timezone,
            deviceUuid: deviceInfo.deviceUUID,
            deviceName: deviceInfo.deviceName,
            deviceType: deviceInfo.deviceType,
            osType: deviceInfo.osType,
            osVersion: deviceInfo.osVersion,
            appVersion: deviceInfo.appVersion
        )

        return requestPlain(.updateDevice(requestDTO: requestDTO))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
