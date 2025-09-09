//
//  UserProfileEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 9/9/25.
//

public struct UserProfileEntity {
    public let profileImg: String
    public let nickname: String
    public let provider: String
    
    public init(profileImg: String, nickname: String, provider: String) {
        self.profileImg = profileImg
        self.nickname = nickname
        self.provider = provider
    }
}
