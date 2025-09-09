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
    func follow(userId: Int) -> AnyPublisher<Void, Error>
    func unfollow(userId: Int) -> AnyPublisher<Bool, Error>
}

public final class DefaultFollowListUseCase: FollowListUseCase {
    
    private let followListRepository: FollowListRepository
        private let followingRepository: FollowingRepository
        
        public init(
            followListRepository: FollowListRepository,
            followingRepository: FollowingRepository
        ) {
            self.followListRepository = followListRepository
            self.followingRepository = followingRepository
        }
    
    public func fetchFollowers(targetUserId: Int) -> AnyPublisher<[Follower], Error> {
        return followListRepository.fetchFollowers(targetUserId: targetUserId)
    }
    
    public func fetchFollowings(targetUserId: Int) -> AnyPublisher<[Follower], Error> {
        return followListRepository.fetchFollowings(targetUserId: targetUserId)
    }
    
    public func follow(userId: Int) -> AnyPublisher<Void, Error> {
        return followingRepository.follow(userId: Int64(userId))
    }
    
    public func unfollow(userId: Int) -> AnyPublisher<Bool, Error> {
        return followingRepository.unfollow(userId: Int64(userId))
    }
}
