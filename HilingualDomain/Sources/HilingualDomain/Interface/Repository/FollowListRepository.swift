//
//  FollowListRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

public protocol FollowListRepository {
    func fetchFollowers(targetUserId: Int) -> AnyPublisher<[Follower], Error>
    func fetchFollowings(targetUserId: Int) -> AnyPublisher<[Follower], Error>
}
