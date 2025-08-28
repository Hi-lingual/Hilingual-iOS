//
//  DefaultFeedProfileInfoRepository.swift
//  HilingualData
//
//  Created by 조영서 on 8/26/25.
//

import Combine
import HilingualDomain
import HilingualNetwork

public final class DefaultFeedProfileInfoRepository: FeedProfileInfoRepository {
    
    private let service: FeedProfileInfoService
    
    public init(service: FeedProfileInfoService) {
        self.service = service
    }
    
    public func fetchProfileInfo(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoEntity, Error> {
        service.fetchProfileInfo(targetUserId: targetUserId)
            .map { dto in
                FeedProfileInfoEntity(
                    userId: dto.data.userId,
                    isMine: dto.data.isMine,
                    profileImg: dto.data.profileImg,
                    nickname: dto.data.nickname,
                    follower: dto.data.follower,
                    following: dto.data.following,
                    streak: dto.data.streak,
                    isFollowing: dto.data.isFollowing,
                    isFollowed: dto.data.isFollowed,
                    isBlocked: dto.data.isBlocked
                )
            }
            .eraseToAnyPublisher()
    }
}
