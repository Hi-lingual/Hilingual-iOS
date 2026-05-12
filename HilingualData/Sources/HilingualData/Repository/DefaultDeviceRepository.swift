//
//  DefaultDeviceRepository.swift
//  HilingualData
//
//  Created by 성현주 on 3/21/26.
//

import Combine
import UIKit

import HilingualDomain
import HilingualNetwork

public final class DefaultDeviceRepository: DeviceRepository {

    private let service: DeviceService

    public init(service: DeviceService) {
        self.service = service
    }
    
    public func updateCurrentDevice() -> AnyPublisher<Void, Error> {
        return service.updateCurrentDevice()
    }
    
    public func updateFcmToken(uuid: String, fcmToken: String) -> AnyPublisher<Void, Error> {
        return service.updateFcmToken(uuid: uuid, fcmToken: fcmToken)
    }
}
