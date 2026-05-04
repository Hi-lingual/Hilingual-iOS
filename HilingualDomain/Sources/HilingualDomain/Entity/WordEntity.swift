//
//  PhraseData.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/13/25.
//

import Foundation

public enum SortOption: Int {
    case alphabetical = 2  // 알파벳순
    case latest = 1        // 최신순
}

public struct WordEntity: Equatable, Hashable {
    public let phraseId: Int
    public let phraseType: [String]
    public let phrase: String
    public let explanation: String?
    public let example: String?
    public let isMarked: Bool
    public let writtenFrom: String?
    public let writtenDate: String?
    public let savedRoot: Int?

    public init(
        phraseId: Int,
        phraseType: [String],
        phrase: String,
        explanation: String?,
        example: String?,
        isMarked: Bool,
        writtenFrom: String?,
        writtenDate: String?,
        savedRoot: Int?
    ) {
        self.phraseId = phraseId
        self.phraseType = phraseType
        self.phrase = phrase
        self.explanation = explanation
        self.example = example
        self.isMarked = isMarked
        self.writtenFrom = writtenFrom
        self.writtenDate = writtenDate
        self.savedRoot = savedRoot
    }
}
