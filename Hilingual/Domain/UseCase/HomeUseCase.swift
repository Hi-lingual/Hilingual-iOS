//
//  HomeUseCase.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

protocol HomeUseCase {
    func fetchCurrentRate() -> AnyPublisher<HomeEntity, Error>
}

final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func fetchCurrentRate() -> AnyPublisher<HomeEntity, Error> {
        return repository.fetchCurrentRate()
    }
}
