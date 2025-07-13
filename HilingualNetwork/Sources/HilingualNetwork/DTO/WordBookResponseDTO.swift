//
//  WordListResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/13/25.
//

import Foundation

public struct WordBookResponseWrapperDTO: Decodable {
    public let code: Int
    public let data: WordBookResponseDTO
    public let message: String
}

public struct WordBookResponseDTO: Decodable {
    public let count: Int
    public let wordList: [WordGroupDTO]
}

public struct WordGroupDTO: Decodable {
    public let group: String
    public let words: [WordDTO]
}

public struct WordDTO: Decodable {
    public let phraseId: Int
    public let phrase: String
    public let phraseType: [String]
}
