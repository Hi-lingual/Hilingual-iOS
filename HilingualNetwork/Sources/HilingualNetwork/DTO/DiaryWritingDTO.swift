//
//  DiaryWritingDTO.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation

public struct DiaryWritingRequestDTO {
    public let originalText: String
    public let date: String
    public let imageFile: Data

    public init(originalText: String, date: String, imageFile: Data) {
        self.originalText = originalText
        self.date = date
        self.imageFile = imageFile
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
