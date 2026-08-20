//
//  DefaultHomeAdWatchService.swift
//  HilingualNetwork
//
//  Created by youngseo on 6/18/26.
//

import Foundation
import Moya
import Combine

public protocol HomeAdWatchService {
    func postAdWatch(requestDTO: HomeAdWatchRequestDTO) -> AnyPublisher<Void, Error>
}

public final class DefaultHomeAdWatchService: BaseService<HomeAdWatchAPI>, HomeAdWatchService {
    public func postAdWatch(requestDTO: HomeAdWatchRequestDTO) -> AnyPublisher<Void, Error> {
        return requestPlain(.postAdWatch(requestDTO))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
