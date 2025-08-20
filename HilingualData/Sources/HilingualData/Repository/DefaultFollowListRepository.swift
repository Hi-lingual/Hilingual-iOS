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
    
    private let service: MockFollowListService  // 나중에 실제 APIService로 교체
    
    public init(service: MockFollowListService) {
        self.service = service
    }
    
    public func fetchFollowers() -> AnyPublisher<[HilingualDomain.Follower], Error> {
        return service.getFollowers()
            .map { response in
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
    
    public func fetchFollowing() -> AnyPublisher<[HilingualDomain.Follower], Error> {
        return service.getFollowing()
            .map { response in
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
