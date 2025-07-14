//
//  DiaryDetailDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

public struct DiaryDetailDTO: Decodable {
    struct Diary: Decodable {
        let code: Int
        let data: CorrectionData?
        let message: String
        
        struct CorrectionData: Decodable {
            let date: String
            let image: String
            let originalFullText: String
            let rewritedFullText: String
            let diffRanges: DiffRange
        }
        
        struct DiffRange: Decodable {
            let start: Int
            let end: Int
            let originalText: String
            let correctedText: String
        }
    }
    
    struct PhraseDTO: Decodable {
        let code: Int
        let data: PhraseData
        let message: String
        
        struct PhraseData: Decodable {
            let phraseList: PhraseList
        }
        
        struct PhraseList: Decodable {
            let phraseId: Int64
            let phraseType: [String]
            let phrase: String
            let explanation: String
            let reason: String
            let isMarked: Bool
        }
    }
}
