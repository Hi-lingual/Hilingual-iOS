//
//  HomeUseCase.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

public protocol HomeUseCase {
    func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error>
    func fetchMonthInfo() -> AnyPublisher<MonthInfoEntity, Error>
}

public final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error> {
        return repository.fetchUserInfo()
    }
    public func fetchMonthInfo() -> AnyPublisher<MonthInfoEntity, Error> {
        return repository.fetchMonthInfo()
    }
}
