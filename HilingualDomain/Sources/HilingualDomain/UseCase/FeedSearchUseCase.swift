//
//  FeedSearchUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/29/25.
//

import Combine

public protocol FeedSearchUseCase {
    func search(keyword: String) -> AnyPublisher<[FeedSearchEntity], Error>
}

public final class DefaultFeedSearchUseCase: FeedSearchUseCase {
    private let repository: FeedSearchRepository
    
    public init(repository: FeedSearchRepository) {
        self.repository = repository
    }
    
    public func search(keyword: String) -> AnyPublisher<[FeedSearchEntity], any Error> {
        return repository.search(keyword: keyword)
    }
}
