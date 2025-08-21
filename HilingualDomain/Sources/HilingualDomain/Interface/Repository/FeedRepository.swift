//
//  FeedRepository.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/20/25.
//

import Combine

public protocol FeedRepository {
    func fetch(type: FeedType) -> AnyPublisher<[FeedEntity], Error>
}
