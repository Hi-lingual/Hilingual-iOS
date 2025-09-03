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
    public let registerStatus: Bool
}

public struct AuthLoginRequestDTO: Encodable {
    public let provider: String
    public let role: String
    public let deviceName: String
    public let deviceType: String
    public let osType: String
    public let osVersion: String
    public let appVersion: String

    public init(
        provider: String,
        role: String,
        deviceName: String,
        deviceType: String,
        osType: String,
        osVersion: String,
        appVersion: String
    ) {
        self.provider = provider
        self.role = role
        self.deviceName = deviceName
        self.deviceType = deviceType
        self.osType = osType
        self.osVersion = osVersion
        self.appVersion = appVersion
    }
}
