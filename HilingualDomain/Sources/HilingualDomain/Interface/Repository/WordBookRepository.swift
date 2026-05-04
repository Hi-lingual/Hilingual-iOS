//
//  WordBookRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/13/25.
//

import Combine

public protocol WordBookRepository {
    func fetchWords(sort: SortOption) -> AnyPublisher<[(date: String, items: [WordEntity])], Error>
    func fetchWordDetail(id: Int) -> AnyPublisher<WordEntity, Error>
    func toggleBookmark(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error>
}
