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
    public let image: ImageFile?

    public struct ImageFile: Encodable {
        public let fileKey: String
        public let purpose: String

        public init(fileKey: String, purpose: String = "PROFILE_UPLOAD") {
            self.fileKey = fileKey
            self.purpose = purpose
        }
    }

    public init(nickname: String, adAlarmAgree: Bool, fileKey: String?) {
        self.nickname = nickname
        self.adAlarmAgree = adAlarmAgree
        if let fileKey {
            self.image = ImageFile(fileKey: fileKey)
        } else {
            self.image = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(adAlarmAgree, forKey: .adAlarmAgree)
        if let image {
            try container.encode(image, forKey: .image)
        }
    }

    enum CodingKeys: String, CodingKey {
        case nickname
        case adAlarmAgree
        case image
    }
}
