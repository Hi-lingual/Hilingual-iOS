//
//  DiaryInfoEntity.swift
//  HilingualDomain
//
//  Created by 조영서 on 7/16/25.
//

public struct DiaryInfoEntity {
    public let diaryId: Int
    public let imageUrl: String?
    public let originalText: String
    public let isPublished: Bool
    public let isAdWatched: Bool

    public init(diaryId: Int, imageUrl: String?, originalText: String, isPublished: Bool, isAdWatched: Bool) {
        self.diaryId = diaryId
        self.imageUrl = imageUrl
        self.originalText = originalText
        self.isPublished = isPublished
        self.isAdWatched = isAdWatched
    }
}
