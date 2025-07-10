//
//  OnBoardingResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation

public struct OnBoardingResponseDTO: Decodable {
    public let code: Int
    public let message: String
    public let data: NicknameAvailabilityDTO
}

public struct NicknameAvailabilityDTO: Decodable {
    public let isAvailable: Bool
}
