//
//  DefaultFeedProfileInfoService.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/26/25.
//

import Foundation
import Combine

public protocol FeedProfileInfoService {
    func fetchProfileInfo(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoResponseDTO, Error>
}

public final class DefaultFeedProfileInfoService: BaseService<FeedProfileAPI>, FeedProfileInfoService {
    public func fetchProfileInfo(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoResponseDTO, Error> {
        request(.fetchProfileInfo(targetUserId: targetUserId), as: FeedProfileInfoResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
