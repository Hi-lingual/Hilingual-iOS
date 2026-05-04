//
//  DefaultFeedSearchService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 9/8/25.
//

import Foundation
import Combine
import Moya

public protocol FeedSearchService {
    func search(keyword: String) -> AnyPublisher<BaseAPIResponse<FeedSearchResponseDTO>, Error>
}

public final class DefaultFeedSearchService: BaseService<FeedSearchAPI>, FeedSearchService {
    public func search(keyword: String) -> AnyPublisher<BaseAPIResponse<FeedSearchResponseDTO>, Error> {
        return request(.searchUsers(keyword: keyword), as: BaseAPIResponse<FeedSearchResponseDTO>.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
