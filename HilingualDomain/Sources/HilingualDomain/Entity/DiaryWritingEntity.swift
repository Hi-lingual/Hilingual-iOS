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
    public let image: ImageFile?

    public init(originalText: String, date: String, fileKey: String?) {
        self.originalText = originalText
        self.date = date
        self.image = fileKey.map { ImageFile(fileKey: $0) }
    }
    
    public struct ImageFile {
        public let fileKey: String
        public let purpose: String

        public init(fileKey: String, purpose: String = "DIARY_IMAGE") {
            self.fileKey = fileKey
            self.purpose = purpose
        }
    }
}

public struct DiaryWritingResponseEntity {
    public let diaryId: Int
    public let isAdWatched: Bool

    public init(diaryId: Int, isAdWatched: Bool) {
        self.diaryId = diaryId
        self.isAdWatched = isAdWatched
    }
}
