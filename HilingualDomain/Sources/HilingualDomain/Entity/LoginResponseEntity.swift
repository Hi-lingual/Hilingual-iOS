//
//  LoginResponseEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Foundation

public struct LoginResponseEntity {
    public let userId: Int64?
    public let accessToken: String
    public let refreshToken: String
    public let isProfileCompleted: Bool?

    public init(
        userId: Int64? = nil,
        accessToken: String,
        refreshToken: String,
        isProfileCompleted: Bool? = nil
    ) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isProfileCompleted = isProfileCompleted
    }
}
