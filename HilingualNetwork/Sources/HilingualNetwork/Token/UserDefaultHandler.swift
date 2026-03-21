//
//  UserDefaultHandler.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/11/25.
//

import Foundation

public struct UserDefaultHandler {
    @UserDefault(key: "accessToken", defaultValue: "")
    public static var accessToken: String

    @UserDefault(key: "refreshToken", defaultValue: "")
    public static var refreshToken: String

    @UserDefault(key: "lastKnownTimezone", defaultValue: "")
    public static var lastKnownTimezone: String
}
