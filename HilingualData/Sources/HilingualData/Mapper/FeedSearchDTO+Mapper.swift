//
//  FeedSearchDTO+Mapper.swift
//  HilingualData
//
//  Created by 신혜연 on 8/29/25.
//

import HilingualDomain
import HilingualNetwork

extension UserDTO {
    func toEntity() -> FeedSearchEntity {
        return FeedSearchEntity(
            userId: self.userId,
            profileImg: self.profileImg,
            nickname: self.nickname,
            isFollowing: self.isFollowing,
            isFollowed: self.isFollowed
        )
    }
}
