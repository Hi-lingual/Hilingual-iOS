//
//  FeedSearchEntity.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/29/25.
//

import Foundation

public struct FeedSearchEntity {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
    public let isFollowing: Bool
    public let isFollowed: Bool
    
    public init(userId: Int, profileImg: String, nickname: String, isFollowing: Bool, isFollowed: Bool) {
        self.userId = userId
        self.profileImg = profileImg
        self.nickname = nickname
        self.isFollowing = isFollowing
        self.isFollowed = isFollowed
    }
}
