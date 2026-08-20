//
//  HomeAdWatchUseCase.swift
//  HilingualDomain
//
//  Created by youngseo on 6/18/26.
//

import Combine

public protocol HomeAdWatchUseCase {
    func execute(targetDate: String) -> AnyPublisher<Void, Error>
}

public final class DefaultHomeAdWatchUseCase: HomeAdWatchUseCase {
    private let repository: HomeAdWatchRepository

    public init(repository: HomeAdWatchRepository) {
        self.repository = repository
    }

    public func execute(targetDate: String) -> AnyPublisher<Void, Error> {
        return repository.postAdWatch(targetDate: targetDate)
    }
}
