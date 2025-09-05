//
//  ProfileEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

public struct ProfileEntity {
    public let nickname: String
    public let adAlarmAgree: Bool
    public let fileKey: String

    public init(nickname: String, adAlarmAgree: Bool, fileKey: String) {
        self.nickname = nickname
        self.adAlarmAgree = adAlarmAgree
        self.fileKey = fileKey
    }
}
