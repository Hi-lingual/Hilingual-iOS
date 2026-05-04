//
//  FeedProfileInfoRepository.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/26/25.
//

import Combine

public protocol FeedProfileInfoRepository {
    func fetchProfileInfo(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoEntity, Error>
}
