//
//  TokenRefreshResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//


public struct TokenRefreshResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
}
