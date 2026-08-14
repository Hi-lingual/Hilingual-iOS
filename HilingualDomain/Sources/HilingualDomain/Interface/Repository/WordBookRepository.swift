//
//  WordBookRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/13/25.
//

import Combine

public protocol WordBookRepository {
    func fetchWords(sort: SortOption, unmemorizedOnly: Bool) -> AnyPublisher<[(date: String, items: [WordEntity])], Error>
    func fetchWordDetail(id: Int) -> AnyPublisher<WordEntity, Error>
    func toggleBookmark(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error>
    func updateMemorization(items: [MemorizationEntity]) -> AnyPublisher<Void, Error>
}

public struct MemorizationEntity: Equatable, Hashable {
    public let phraseId: Int
    public let isMemorized: Bool

    public init(phraseId: Int, isMemorized: Bool) {
        self.phraseId = phraseId
        self.isMemorized = isMemorized
    }
}
