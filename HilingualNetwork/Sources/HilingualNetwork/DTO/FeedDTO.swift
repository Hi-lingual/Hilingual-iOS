//
//  FeedDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/20/25.
//

import Foundation

public struct FeedListDTO: Decodable {
    public let diaryList: [FeedItemDTO]
    // 팔로잉 응답에만 존재해야 함! optional로 처리
    public var haveFollowing: Bool? = nil
}

// 추천 피드
public struct RecommendedFeedResponseDTO: Decodable {
    public let code: Int
    public let data: FeedListDTO
    public let message: String
}

// 팔로잉 피드
public struct FollowingFeedResponseDTO: Decodable {
    public let code: Int
    public let data: FeedListDTO
    public let message: String
}

public struct FeedItemDTO: Decodable {
    public let profile: ProfileDTO
    public let diary: DiaryDTO

    public struct ProfileDTO: Decodable {
        public let userId: Int
        public let isMine: Bool
        public let profileImg: String
        public let nickname: String
        public let streak: Int
    }

    public struct DiaryDTO: Decodable {
        public let diaryId: Int
        public let sharedDate: Int
        public let likeCount: Int
        public let isLiked: Bool
        public let diaryImg: String?
        public let originalText: String
    }
}
