//
//  UserProfileResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/9/25.
//

import Foundation

public struct UserProfileResponseDTO: Decodable {
    public let profileImg: String
    public let nickname: String
    public let provider: String
}
