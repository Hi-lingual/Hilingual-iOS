//
//  SharedDiaryResponseDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/26/25.
//

import Foundation

public struct SharedDiaryResponseDTO: Decodable {
    public let code: Int
    public let data: SharedProfileData
    public let message: String
    
    public struct SharedProfileData: Decodable {
        public let isMine: Bool
        public let profile: Profile
        public let diary: Diary
    }
    
    public struct Profile: Decodable {
        public let userId: Int
        public let profileImg: String
        public let nickname: String
        public let streak: Int
    }
    
    public struct Diary: Decodable {
        public let sharedDate: Int
        public let likeCount: Int
        public let isLiked: Bool
    }
}
