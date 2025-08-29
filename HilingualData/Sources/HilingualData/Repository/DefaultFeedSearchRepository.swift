//
//  DefaultFeedSearchRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 8/29/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultFeedSearchRepository: FeedSearchRepository {
    private let service: FeedSearchService
    
    public init(service: FeedSearchService) {
        self.service = service
    }
    
    public func search(keyword: String) -> AnyPublisher<[FeedSearchEntity], Error> {
        return service.search(keyword: keyword)
            .map { responseDTO in
                return responseDTO.data.userList.map { $0.toEntity() }
            }
            .eraseToAnyPublisher()
    }
}
