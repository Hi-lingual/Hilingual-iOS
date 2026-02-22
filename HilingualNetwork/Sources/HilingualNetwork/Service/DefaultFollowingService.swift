//
//  DefaultFollowingService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 9/9/25.
//

import Foundation
import Combine

public protocol FollowingService {
    func follow(userId: Int64) -> AnyPublisher<Void, Error>
    func unfollow(userId: Int64) -> AnyPublisher<UnfollowResponseDTO, Error>
}

public final class DefaultFollowingService: BaseService<FollowingAPI>, FollowingService {
    public func follow(userId: Int64) -> AnyPublisher<Void, Error> {
        return requestPlain(.follow(targetUserId: userId))
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func unfollow(userId: Int64) -> AnyPublisher<UnfollowResponseDTO, Error> {
        return request(.unfollow(targetUserId: userId), as: UnfollowResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
