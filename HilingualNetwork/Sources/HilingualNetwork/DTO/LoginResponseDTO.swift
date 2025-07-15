//
//  LoginResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation

public struct LoginResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let isProfileCompleted: Bool
}
