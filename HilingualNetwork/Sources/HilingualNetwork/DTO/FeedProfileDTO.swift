//
//  FeedProfileDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/22/25.
//

import Foundation

// MARK: - 공유 피드
public struct SharedFeedResponseDTO: Decodable {
    public let code: Int
    public let data: SharedFeedDataDTO
    public let message: String
}

public struct SharedFeedDataDTO: Decodable {
    public let profile: SharedProfileDTO
    public let diaryList: [ProfileDiaryDTO]
}

public struct SharedProfileDTO: Decodable {
    public let profileImg: String
    public let nickname: String
}

// MARK: - 공감 피드
public struct LikedFeedResponseDTO: Decodable {
    public let code: Int
    public let data: LikedFeedDataDTO
    public let message: String
}

public struct LikedFeedDataDTO: Decodable {
    public let diaryList: [FeedProfileItemDTO]
}

public struct FeedProfileItemDTO: Decodable {
    public let profile: ProfileDTO
    public let diary: ProfileDiaryDTO

    public struct ProfileDTO: Decodable {
        public let userId: Int
        public let isMine: Bool
        public let profileImg: String?
        public let nickname: String
        public let streak: Int
    }

    public struct ProfileDiaryDTO: Decodable {
        public let diaryId: Int
        public let sharedDate: Int
        public let likeCount: Int
        public let isLiked: Bool
        public let diaryImg: String?
        public let originalText: String
    }
}

// MARK: - 공통 일기 컨텐츠
public struct ProfileDiaryDTO: Decodable {
    public let diaryId: Int
    public let sharedDate: Int
    public let likeCount: Int
    public let isLiked: Bool
    public let diaryImg: String?
    public let originalText: String
}
