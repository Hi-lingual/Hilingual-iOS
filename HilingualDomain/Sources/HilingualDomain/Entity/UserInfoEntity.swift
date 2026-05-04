//
//  UserInfoEntity.swift
//  HilingualDomain
//
//  Created by 조영서 on 7/16/25.
//

public struct UserInfoEntity {
    public let nickname: String
    public let profileImg: String
    public let totalDiaries: Int
    public let streak: Int
    public let newAlarm: Bool

    public init(nickname: String, profileImg: String, totalDiaries: Int, streak: Int, newAlarm: Bool) {
        self.nickname = nickname
        self.profileImg = profileImg
        self.totalDiaries = totalDiaries
        self.streak = streak
        self.newAlarm = newAlarm
    }
}
