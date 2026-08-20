//
//  DefaultHomeAdWatchRepository.swift
//  HilingualData
//
//  Created by youngseo on 6/18/26.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultHomeAdWatchRepository: HomeAdWatchRepository {
    private let service: HomeAdWatchService

    public init(service: HomeAdWatchService) {
        self.service = service
    }

    public func postAdWatch(targetDate: String) -> AnyPublisher<Void, Error> {
        let requestDTO = HomeAdWatchRequestDTO(targetDate: targetDate)

        return service.postAdWatch(requestDTO: requestDTO)
            .eraseToAnyPublisher()
    }
}
