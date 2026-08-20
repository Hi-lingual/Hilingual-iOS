//
//  PhraseData.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/14/25.
//

public struct PhraseData: Codable {
    let phraseId: Int64
    let phraseType: [String]
    let phrase: String
    let explanation: String
    let reason: String
    let createdAt: String
    var isMarked: Bool
    var isMemorized: Bool = false
}
