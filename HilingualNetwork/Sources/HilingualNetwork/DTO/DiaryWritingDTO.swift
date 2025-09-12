//
//  DiaryWritingDTO.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation

public struct DiaryWritingRequestDTO: Encodable {
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

public struct DiaryWritingResponseDTO: Decodable {
    public let code: Int
    public let data: DiaryIdDTO
    public let message: String
}

public struct DiaryIdDTO: Decodable {
    public let diaryId: Int
}
