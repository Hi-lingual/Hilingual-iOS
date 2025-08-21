//
//  BlockedUser.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/21/25.
//

public struct BlockedUserEntity: Equatable {
    public let userId: Int
    public let nickname: String
    public let profileImg: String

    public init(userId: Int, nickname: String, profileImg: String) {
        self.userId = userId
        self.nickname = nickname
        self.profileImg = profileImg
    }
}
