//
//  RecommendedVocaEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/16/25.
//

import Foundation

public struct RecommendedExpressionEntity {
    public let vocaList: [Phrase]
    
    public struct Phrase {
        public let phraseId: Int
        public let phraseType: [String]
        public let phrase: String
        public let explanation: String
        public let reason: String
        public let isBookmarked: Bool
        
        public init(phraseId: Int, phraseType: [String], phrase: String, explanation: String, reason: String, isBookmarked: Bool) {
            self.phraseId = phraseId
            self.phraseType = phraseType
            self.phrase = phrase
            self.explanation = explanation
            self.reason = reason
            self.isBookmarked = isBookmarked
        }
    }
    
    public init(vocaList: [Phrase]) {
        self.vocaList = vocaList
    }
}

