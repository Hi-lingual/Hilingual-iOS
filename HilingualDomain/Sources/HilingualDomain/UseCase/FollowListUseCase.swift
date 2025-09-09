//
//  FollowListUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

public protocol FollowListUseCase {
    func fetchFollowers(targetUserId: Int) -> AnyPublisher<[Follower], Error>
    func fetchFollowings(targetUserId: Int) -> AnyPublisher<[Follower], Error>
}

public final class DefaultFollowListUseCase: FollowListUseCase {
    
    private let repository: FollowListRepository
    
    public init(repository: FollowListRepository) {
        self.repository = repository
    }
    
    public func fetchFollowers(targetUserId: Int) -> AnyPublisher<[Follower], Error> {
        return repository.fetchFollowers(targetUserId: targetUserId)
    }
    
    public func fetchFollowings(targetUserId: Int) -> AnyPublisher<[Follower], Error> {
        return repository.fetchFollowings(targetUserId: targetUserId)
    }
}
