//
//  DefaultFollowingRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 9/9/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultFollowingRepository: FollowingRepository {
    private let service: FollowingService
    
    public init(service: FollowingService) {
        self.service = service
    }
    
    public func follow(userId: Int64) -> AnyPublisher<Void, Error> {
        return service.follow(userId: userId)
    }
    
    public func unfollow(userId: Int64) -> AnyPublisher<Bool, Error> {
        return service.unfollow(userId: userId)
            .map { $0.data.followedBy }
            .eraseToAnyPublisher()
    }
}
