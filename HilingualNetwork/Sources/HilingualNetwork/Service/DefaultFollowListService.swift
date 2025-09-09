//
//  DefaultFollowListService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 8/17/25.
//

import Foundation
import Combine
import Moya

public protocol FollowListService {
    func fetchFollowers(targetUserId: Int) -> AnyPublisher<FollowListResponseDTO, Error>
    func fetchFollowings(targetUserId: Int) -> AnyPublisher<FollowListResponseDTO, Error>
}

public final class DefaultFollowListService: BaseService<FollowListAPI>, FollowListService {
    public func fetchFollowers(targetUserId: Int) -> AnyPublisher<FollowListResponseDTO, Error> {
        return request(.fetchFollowers(targetUserId: targetUserId), as: FollowListResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func fetchFollowings(targetUserId: Int) -> AnyPublisher<FollowListResponseDTO, Error> {
        return request(.fetchFollowings(targetUserId: targetUserId), as: FollowListResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
