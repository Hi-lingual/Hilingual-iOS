//
//  FeedProfileRepository.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/22/25.
//

import Combine

public protocol FeedProfileRepository {
    func fetch(type: FeedProfileType, targetUserId: Int64) -> AnyPublisher<([FeedEntity], Bool?), Error>
}
