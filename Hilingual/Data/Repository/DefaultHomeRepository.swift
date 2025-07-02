//
//  DefaultHomeRepository.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

//final class DefaultHomeRepository: HomeRepository {
//    private let provider: MoyaProvider<ExchangeRateAPI>
//
//    init(provider: MoyaProvider<ExchangeRateAPI> = .init()) {
//        self.provider = provider
//    }
//
//    func fetchCurrentRate() -> AnyPublisher<ExchangeRate, Error> {
//        return provider.requestPublisher(.getRate)
//            .map(ExchangeRateResponseDTO.self)
//            .map { $0.toDomain() }
//            .eraseToAnyPublisher()
//    }
//}
