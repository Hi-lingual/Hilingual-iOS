//
//  FeedEntity.swift
//  HilingualDomain
//
//  Created by 조영서 on 8/20/25.
//

import Foundation

public struct FeedEntity {
    public let profile: FeedProfile
    public let diary: FeedDiary

    public init(profile: FeedProfile, diary: FeedDiary) {
        self.profile = profile
        self.diary = diary
    }
}

public struct FeedProfile {
    public let userId: Int
    public let isMine: Bool
    public let profileImg: String
    public let nickname: String
    public let streak: Int?

    public init(userId: Int,
                isMine: Bool,
                profileImg: String,
                nickname: String,
                streak: Int?)
    {
        self.userId = userId
        self.isMine = isMine
        self.profileImg = profileImg
        self.nickname = nickname
        self.streak = streak
    }
}

public struct FeedDiary {
    public let diaryId: Int
    public let sharedDate: Int
    public let likeCount: Int
    public let isLiked: Bool
    public let diaryImg: String?
    public let originalText: String

    public init(
        diaryId: Int,
        sharedDate: Int,
        likeCount: Int,
        isLiked: Bool,
        diaryImg: String?,
        originalText: String)
    {
        self.diaryId = diaryId
        self.sharedDate = sharedDate
        self.likeCount = likeCount
        self.isLiked = isLiked
        self.diaryImg = diaryImg
        self.originalText = originalText
    }
}
