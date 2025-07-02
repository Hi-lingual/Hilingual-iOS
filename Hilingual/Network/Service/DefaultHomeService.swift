//
//  HomeService.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import CombineMoya
import Moya
import Combine

protocol HomeService {
    func fetchExchangeRate() -> AnyPublisher<HomeResponseDTO, Error>
}

final class DefaultHomeService: HomeService {
    private var provider = MoyaProvider<HomeAPI>(plugins: [MoyaLoggerPlugin()])

    init(provider: MoyaProvider<HomeAPI> = NetworkProvider.make()) {
        self.provider = provider
    }

    func fetchExchangeRate() -> AnyPublisher<HomeResponseDTO, Error> {
        return provider.requestPublisher(.getRate)
            .map(HomeResponseDTO.self)
            .mapError { $0 as Error } 
            .eraseToAnyPublisher()
    }
}
