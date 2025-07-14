//
//  PhraseEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

public struct PhraseEntity {
    let code: Int
    let data: PhraseData
    let message: String
    
    public struct PhraseData {
        let phraseList: PhraseList
    }
 
    public struct PhraseList {
        let phraseId: Int64
        let phraseType: [String]
        let phrase: String
        let explanation: String
        let reason: String
        let isMarked: Bool
    }
}

