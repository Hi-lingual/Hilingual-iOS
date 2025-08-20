//
//  MockFollowListService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 8/20/25.
//

import Foundation
import Combine

public protocol FollowListService {
    func getFollowers() -> AnyPublisher<FollowListResponseDTO, Error>
    func getFollowing() -> AnyPublisher<FollowListResponseDTO, Error>
}

public final class MockFollowListService: FollowListService {
    public init() {}
    
    public func getFollowers() -> AnyPublisher<FollowListResponseDTO, Error> {
        return Just(FollowListResponseDTO.mockFollowers)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func getFollowing() -> AnyPublisher<FollowListResponseDTO, Error> {
        return Just(FollowListResponseDTO.mockFollowing)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
