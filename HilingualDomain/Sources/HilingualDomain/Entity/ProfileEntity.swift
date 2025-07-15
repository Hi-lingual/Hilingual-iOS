//
//  ProfileEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//


public struct ProfileEntity {
    public let nickname: String
    public let profileImg: String

    public init(nickname: String, profileImg: String) {
        self.nickname = nickname
        self.profileImg = profileImg
    }
}
