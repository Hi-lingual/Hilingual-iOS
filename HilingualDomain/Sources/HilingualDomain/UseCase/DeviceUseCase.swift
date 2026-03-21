//
//  DeviceUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 3/21/26.
//

import Combine

public protocol DeviceUseCase {
    func updateCurrentDevice() -> AnyPublisher<Void, Error>
}

public final class DefaultDeviceUseCase: DeviceUseCase {

    private let repository: DeviceRepository

    public init(repository: DeviceRepository) {
        self.repository = repository
    }

    public func updateCurrentDevice() -> AnyPublisher<Void, Error> {
        return repository.updateCurrentDevice()
    }
}
