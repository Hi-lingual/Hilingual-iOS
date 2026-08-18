//
//  MemorizationEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/18/26.
//

import Foundation

public struct MemorizationEntity: Equatable, Hashable {
    public let phraseId: Int
    public let isMemorized: Bool

    public init(phraseId: Int, isMemorized: Bool) {
        self.phraseId = phraseId
        self.isMemorized = isMemorized
    }
}
