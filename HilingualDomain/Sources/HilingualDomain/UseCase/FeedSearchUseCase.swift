//
//  FeedSearchUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/29/25.
//

import Combine

public protocol FeedSearchUseCase {
    func search(keyword: String) -> AnyPublisher<[FeedSearchEntity], Error>
    func follow(userId: Int) -> AnyPublisher<Void, Error>
    func unfollow(userId: Int) -> AnyPublisher<Bool, Error>
}

public final class DefaultFeedSearchUseCase: FeedSearchUseCase {
    private let feedRepository: FeedSearchRepository
    private let followingRepository: FollowingRepository
    
    public init(
        feedRepository: FeedSearchRepository,
        followingRepository: FollowingRepository
    ) {
        self.feedRepository = feedRepository
        self.followingRepository = followingRepository
    }
    public func search(keyword: String) -> AnyPublisher<[FeedSearchEntity], any Error> {
        return feedRepository.search(keyword: keyword)
    }
    
    public func follow(userId: Int) -> AnyPublisher<Void, Error> {
        return followingRepository.follow(userId: Int64(userId))
    }
    
    public func unfollow(userId: Int) -> AnyPublisher<Bool, Error> {
        return followingRepository.unfollow(userId: Int64(userId))
    }
}
