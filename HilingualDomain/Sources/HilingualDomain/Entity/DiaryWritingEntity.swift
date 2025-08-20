//
//  DiaryWritingEntity.swift
//  HilingualDomain
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation

public struct DiaryWritingEntity {
    public let originalText: String
    public let date: String
    public let imageFile: Data?

    public init(originalText: String, date: String, imageFile: Data?) {
        self.originalText = originalText
        self.date = date
        self.imageFile = imageFile
    }
}

public struct DiaryWritingResponseEntity {
    public let diaryId: Int

    public init(diaryId: Int) {
        self.diaryId = diaryId
    }
}

