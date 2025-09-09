//
//  DefaultFollowListRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultFollowListRepository: FollowListRepository {
    
    private let service: FollowListService
    
    public init(service: FollowListService) {
        self.service = service
    }
    
    public func fetchFollowers(targetUserId: Int) -> AnyPublisher<[HilingualDomain.Follower], Error> {
        return service.fetchFollowers(targetUserId: targetUserId)
            .map { response in
                // FollowListResponseDTO의 data에 followerList가 직접 있습니다.
                response.data.followerList?.map { dto in
                    HilingualDomain.Follower(
                        userId: dto.userId,
                        profileImg: dto.profileImg,
                        nickname: dto.nickname,
                        isFollowing: dto.isFollowing,
                        isFollowed: dto.isFollowed
                    )
                } ?? []
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchFollowings(targetUserId: Int) -> AnyPublisher<[HilingualDomain.Follower], Error> {
        return service.fetchFollowings(targetUserId: targetUserId)
            .map { response in
                // FollowListResponseDTO의 data에 followingList가 직접 있습니다.
                response.data.followingList?.map { dto in
                    HilingualDomain.Follower(
                        userId: dto.userId,
                        profileImg: dto.profileImg,
                        nickname: dto.nickname,
                        isFollowing: dto.isFollowing,
                        isFollowed: dto.isFollowed
                    )
                } ?? []
            }
            .eraseToAnyPublisher()
    }
}
