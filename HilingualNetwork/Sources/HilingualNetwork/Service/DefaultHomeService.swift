//
//  HomeService.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya
import Combine

public protocol HomeService {
    func fetchExchangeRate() -> AnyPublisher<HomeResponseDTO, Error>
}

public final class DefaultHomeService: BaseService<HomeAPI>, HomeService {
    public func fetchExchangeRate() -> AnyPublisher<HomeResponseDTO, Error> {
        return request(.getRate, as: HomeResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

