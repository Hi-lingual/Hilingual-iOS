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
    public let isBlocked: Bool

    public init(
        userId: Int,
        nickname: String,
        profileImg: String,
        isBlocked: Bool = true
    ) {
        self.userId = userId
        self.nickname = nickname
        self.profileImg = profileImg
        self.isBlocked = isBlocked
    }
}
