//
//  FollowingRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 9/9/25.
//

import Combine

public protocol FollowingRepository {
    func follow(userId: Int64) -> AnyPublisher<Void, Error>
    func unfollow(userId: Int64) -> AnyPublisher<Bool, Error>
}
