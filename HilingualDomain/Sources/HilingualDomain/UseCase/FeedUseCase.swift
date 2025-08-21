//
//  FeedUseCase.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/20/25.
//

import Combine

public protocol FeedUseCase {
    func execute(type: FeedType) -> AnyPublisher<[FeedEntity], Error>
}

public final class DefaultFeedUseCase: FeedUseCase {
    private let repository: FeedRepository

    public init(repository: FeedRepository) {
        self.repository = repository
    }

    public func execute(type: FeedType) -> AnyPublisher<[FeedEntity], Error> {
        return repository.fetch(type: type)
    }
}

// 얜 어디로 가야 할까...
public enum FeedType {
    case recommended
    case following
}
