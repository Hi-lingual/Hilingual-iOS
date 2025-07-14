//
//  PhraseData.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/13/25.
//

import Foundation

public enum SortOption: Int {
    case alphabetical = 1  // 가나다순 (기본)
    case latest = 2        // 최신순
}

public struct WordEntity: Equatable, Hashable {
    public let phraseId: Int
    public let phraseType: [String]
    public let phrase: String
    public let explanation: String?
    public let example: String?
    public let isMarked: Bool
    public let createdAt: String?

    public init(
        phraseId: Int,
        phraseType: [String],
        phrase: String,
        explanation: String?,
        example: String?,
        isMarked: Bool,
        createdAt: String?
    ) {
        self.phraseId = phraseId
        self.phraseType = phraseType
        self.phrase = phrase
        self.explanation = explanation
        self.example = example
        self.isMarked = isMarked
        self.createdAt = createdAt
    }
}
