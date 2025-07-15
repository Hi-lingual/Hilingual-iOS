//
//  OnBoardingResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation

//MARK: - OnBoarding

public struct OnBoardingResponseDTO: Decodable {
    public let code: Int
    public let message: String
    public let data: NicknameAvailabilityDTO
}

public struct NicknameAvailabilityDTO: Decodable {
    public let isAvailable: Bool
}

// MARK: - RegisterProfile

public struct RegisterProfileRequestDTO: Encodable {
    public let nickname: String
    public let profileImg: String
}
