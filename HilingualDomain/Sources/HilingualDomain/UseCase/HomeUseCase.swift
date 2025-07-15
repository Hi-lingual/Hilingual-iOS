//
//  HomeUseCase.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

//인터페이스 외부에서는 이친구를 의존합니다
public protocol HomeUseCase {
    func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error>
}

public final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error> {
        return repository.fetchUserInfo()
    }
}
