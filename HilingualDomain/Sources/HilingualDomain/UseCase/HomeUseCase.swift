//
//  HomeUseCase.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

//인터페이스 외부에서는 이친구를 의존합니다
public protocol HomeUseCase {
    func fetchCurrentRate() -> AnyPublisher<HomeEntity, Error>
}

//실제 구현부 
public final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository //추상화된 레포지토리 의존

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func fetchCurrentRate() -> AnyPublisher<HomeEntity, Error> {
        return repository.fetchCurrentRate() //레포지토리에 요청 조회좀 해주셈 ㅋㅋ
    }
}
