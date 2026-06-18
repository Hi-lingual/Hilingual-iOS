//
//  DiaryRecoveryRequestDTO.swift
//  HilingualNetwork
//
//  Created by youngseo on 6/18/26.
//

import Foundation

public struct DiaryRecoveryRequestDTO: Encodable {
    public let originalText: String
    public let date: String
    public let image: ImageFile?
    
    public struct ImageFile: Encodable {
        public let fileKey: String
        public let purpose: String

        public init(fileKey: String, purpose: String = "DIARY_IMAGE") {
            self.fileKey = fileKey
            self.purpose = purpose
        }
    }

    public init(originalText: String, date: String, fileKey: String?) {
        self.originalText = originalText
        self.date = date
        if let fileKey {
            self.image = ImageFile(fileKey: fileKey)
        } else {
            self.image = nil
        }
    }
}

public struct DiaryRecoveryResponseDTO: Decodable {
    public let code: Int
    public let data: DiaryRecoveryDataDTO
    public let message: String
}

public struct DiaryRecoveryDataDTO: Decodable {
    public let diaryId: Int
    public let isAdWatched: Bool
}
