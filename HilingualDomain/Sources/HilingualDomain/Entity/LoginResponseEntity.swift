//
//  LoginResponseEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Foundation

public struct LoginResponseEntity {
    public let accessToken: String
    public let refreshToken: String
    public let isProfileCompleted: Bool

    public init(
        accessToken: String,
        refreshToken: String,
        isProfileCompleted: Bool
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isProfileCompleted = isProfileCompleted
    }
}
