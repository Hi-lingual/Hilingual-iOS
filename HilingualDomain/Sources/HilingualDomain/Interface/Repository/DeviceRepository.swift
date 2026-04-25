//
//  DeviceRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 3/21/26.
//

import Combine

public protocol DeviceRepository {
    func updateCurrentDevice() -> AnyPublisher<Void, Error>
}
