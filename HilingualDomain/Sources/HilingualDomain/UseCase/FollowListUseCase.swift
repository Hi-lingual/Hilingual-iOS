//
//  FollowListUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

public protocol FollowListUseCase {
    func fetchFollowers() -> AnyPublisher<[Follower], Error>
    func fetchFollowing() -> AnyPublisher<[Follower], Error>
}

public final class DefaultFollowListUseCase: FollowListUseCase {
    
    private let repository: FollowListRepository
    
    public init(repository: FollowListRepository) {
        self.repository = repository
    }
    
    public func fetchFollowers() -> AnyPublisher<[Follower], Error> {
        repository.fetchFollowers()
    }
    
    public func fetchFollowing() -> AnyPublisher<[Follower], Error> {
        repository.fetchFollowing()
    }
}
