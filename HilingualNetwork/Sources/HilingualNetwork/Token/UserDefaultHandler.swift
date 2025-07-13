//
//  UserDefaultHandler.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/11/25.
//

import Foundation

struct UserDefaultHandler {
    @UserDefault(key: "accessToken", defaultValue: "")
    static var accessToken: String

    @UserDefault(key: "refreshToken", defaultValue: "")
    static var refreshToken: String
}
