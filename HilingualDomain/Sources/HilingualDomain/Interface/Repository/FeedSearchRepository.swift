//
//  FeedSearchRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/29/25.
//

import Combine

public protocol FeedSearchRepository {
    func search(keyword: String) -> AnyPublisher<[FeedSearchEntity], Error>
}
