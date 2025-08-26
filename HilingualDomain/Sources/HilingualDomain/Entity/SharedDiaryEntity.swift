//
//  SharedDiaryEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/26/25.
//

public struct SharedDiaryEntity {
    public let isMine: Bool
    public let profile: Profile
    public let diary: Diary
    
    public struct Profile {
        public let userId: Int
        public let profileImg: String
        public let nickname: String
        public let streak: Int
        
        public init(
            userId: Int,
            profileImg: String,
            nickname: String,
            streak: Int
        ) {
            self.userId = userId
            self.profileImg = profileImg
            self.nickname = nickname
            self.streak = streak
        }
    }
    
    public struct Diary {
        public let sharedDate: Int
        public let likeCount: Int
        public let isLiked: Bool
        
        public init(sharedDate: Int, likeCount: Int, isLiked: Bool) {
            self.sharedDate = sharedDate
            self.likeCount = likeCount
            self.isLiked = isLiked
        }
    }
    
    public init(isMine: Bool, profile: Profile, diary: Diary) {
        self.isMine = isMine
        self.profile = profile
        self.diary = diary
    }
}
