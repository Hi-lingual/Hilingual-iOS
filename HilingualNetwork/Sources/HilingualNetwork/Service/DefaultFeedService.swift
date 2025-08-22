//
//  DefaultFeedService.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/20/25.
//

import Foundation
import Combine

public protocol FeedService {
    func fetchRecommendedFeed() -> AnyPublisher<RecommendedFeedResponseDTO, Error>
    func fetchFollowingFeed()   -> AnyPublisher<FollowingFeedResponseDTO, Error>
}

public final class DefaultFeedService: BaseService<FeedAPI>, FeedService {
    public func fetchRecommendedFeed() -> AnyPublisher<RecommendedFeedResponseDTO, Error> {
        request(.fetchRecommendedFeed, as: RecommendedFeedResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func fetchFollowingFeed() -> AnyPublisher<FollowingFeedResponseDTO, Error> {
        request(.fetchFollowingFeed, as: FollowingFeedResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
