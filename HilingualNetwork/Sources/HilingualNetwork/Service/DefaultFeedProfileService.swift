//
//  DefaultFeedProfileService.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/22/25.
//

import Foundation
import Combine

public protocol FeedProfileService {
    func fetchSharedFeed(targetUserId: Int64) -> AnyPublisher<SharedFeedResponseDTO, Error>
    func fetchLikedFeed(targetUserId: Int64)   -> AnyPublisher<LikedFeedResponseDTO, Error>
}

public final class DefaultFeedProfileService: BaseService<FeedProfileAPI>, FeedProfileService {
    public func fetchSharedFeed(targetUserId: Int64)
    -> AnyPublisher<SharedFeedResponseDTO, Error> {
        request(.fetchSharedFeed(targetUserId: targetUserId), as: SharedFeedResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func fetchLikedFeed(targetUserId: Int64)
    -> AnyPublisher<LikedFeedResponseDTO, Error> {
        request(.fetchLikedFeed(targetUserId: targetUserId), as: LikedFeedResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
