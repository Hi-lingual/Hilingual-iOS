//
//  MemorizationRequestDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/14/26.
//

import Foundation

public struct MemorizationUpdateRequestDTO: Encodable {
    public let items: [MemorizationItemDTO]

    public init(items: [MemorizationItemDTO]) {
        self.items = items
    }
}

public struct MemorizationItemDTO: Encodable {
    public let phraseId: Int
    public let isMemorized: Bool

    public init(phraseId: Int, isMemorized: Bool) {
        self.phraseId = phraseId
        self.isMemorized = isMemorized
    }
}
