//
//  FeedProfileInfoEntity.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/26/25.
//

import Foundation

public struct FeedProfileInfoEntity {
    public let userId: Int
    public let isMine: Bool
    public let profileImg: String
    public let nickname: String
    public let follower: Int
    public let following: Int
    public let streak: Int
    public let isFollowing: Bool?
    public let isFollowed: Bool?
    public let isBlocked: Bool?

    public init(userId: Int,
                isMine: Bool,
                profileImg: String,
                nickname: String,
                follower: Int,
                following: Int,
                streak: Int,
                isFollowing: Bool?,
                isFollowed: Bool?,
                isBlocked: Bool?)
    {
        self.userId = userId
        self.isMine = isMine
        self.profileImg = profileImg
        self.nickname = nickname
        self.follower = follower
        self.following = following
        self.streak = streak
        self.isFollowing = isFollowing
        self.isFollowed = isFollowed
        self.isBlocked = isBlocked
    }
}
