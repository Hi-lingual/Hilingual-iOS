//
//  RecommendedVocaResponseDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/16/25.
//

import Foundation

public struct RecommendedVocaResponseDTO: Decodable {
    public let code: Int
    public let data: PhraseList
    public let message: String
    
    public struct PhraseList: Decodable {
        public let phraseList: [Phrase]
    }
    
    public struct Phrase: Decodable {
        public let phraseId: Int
        public let phraseType: [String]
        public let phrase: String
        public let explanation: String
        public let reason: String
        public let isBookmarked: Bool
    }
}
