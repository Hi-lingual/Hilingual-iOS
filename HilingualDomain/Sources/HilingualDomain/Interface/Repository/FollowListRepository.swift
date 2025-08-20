//
//  FollowListRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

public protocol FollowListRepository {
    func fetchFollowers() -> AnyPublisher<[Follower], Error>
    func fetchFollowing() -> AnyPublisher<[Follower], Error>
}
