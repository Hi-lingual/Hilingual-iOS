//
//  HomeService.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya
import Combine

protocol HomeService {
    func fetchExchangeRate() -> AnyPublisher<HomeResponseDTO, Error>
}

final class DefaultHomeService: BaseService<HomeAPI>, HomeService {
    func fetchExchangeRate() -> AnyPublisher<HomeResponseDTO, Error> {
        return request(.getRate, as: HomeResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

