//
//  UserInfoDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 7/16/25.
//

import Foundation

public struct UserInfoDTO: Decodable {
    public let code: Int
    public let data: UserInfoDataDTO?
    public let message: String
}

public struct UserInfoDataDTO: Decodable {
    public let nickname: String
    public let profileImg: String
    public let totalDiaries: Int
    public let streak: Int
}
