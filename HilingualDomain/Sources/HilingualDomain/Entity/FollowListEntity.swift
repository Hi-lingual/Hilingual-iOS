//
//  FollowListEntity.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/20/25.
//

import Foundation

public struct Follower {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
    public let isFollowing: Bool   // 내가 상대를 팔로우 중인지
    public let isFollowed: Bool    // 상대가 나를 팔로우 중인지

    public init(userId: Int, profileImg: String, nickname: String,
                isFollowing: Bool, isFollowed: Bool) {
        self.userId = userId
        self.profileImg = profileImg
        self.nickname = nickname
        self.isFollowing = isFollowing
        self.isFollowed = isFollowed
    }
}
