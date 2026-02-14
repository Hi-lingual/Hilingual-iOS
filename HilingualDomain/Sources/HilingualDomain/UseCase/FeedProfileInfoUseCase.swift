//
//  FeedProfileInfoUseCase.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/26/25.
//

import Combine

public protocol FeedProfileInfoUseCase {
    func execute(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoEntity, Error>
}

public final class DefaultFeedProfileInfoUseCase: FeedProfileInfoUseCase {
    private let repository: FeedProfileInfoRepository

    public init(repository: FeedProfileInfoRepository) {
        self.repository = repository
    }

    public func execute(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoEntity, Error> {
        return repository.fetchProfileInfo(targetUserId: targetUserId)
    }
}
