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
    public let adAlarmAgree: Bool
    public let image: ImageFile

    public struct ImageFile: Encodable {
        public let fileKey: String
        public let purpose: String 

        public init(fileKey: String, purpose: String = "PROFILE_UPLOAD") {
            self.fileKey = fileKey
            self.purpose = purpose
        }
    }

    public init(nickname: String, adAlarmAgree: Bool, fileKey: String) {
        self.nickname = nickname
        self.adAlarmAgree = adAlarmAgree
        self.image = ImageFile(fileKey: fileKey)
    }
}
