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

    public init(diaryId: Int, imageUrl: String?, originalText: String) {
        self.diaryId = diaryId
        self.imageUrl = imageUrl
        self.originalText = originalText
    }
}
