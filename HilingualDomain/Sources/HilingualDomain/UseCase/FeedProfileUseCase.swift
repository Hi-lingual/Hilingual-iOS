//
//  FeedProfileUseCase.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/22/25.
//

import Combine

public protocol FeedProfileUseCase {
    func execute(type: FeedProfileType, targetUserId: Int64)
    -> AnyPublisher<([FeedEntity], Bool?), Error>
}

public final class DefaultFeedProfileUseCase: FeedProfileUseCase {
    private let repository: FeedProfileRepository

    public init(repository: FeedProfileRepository) {
        self.repository = repository
    }

    public func execute(type: FeedProfileType, targetUserId: Int64)
    -> AnyPublisher<([FeedEntity], Bool?), Error> {
        return repository.fetch(type: type, targetUserId: targetUserId)
    }
}

public enum FeedProfileType {
    case shared
    case liked
}
