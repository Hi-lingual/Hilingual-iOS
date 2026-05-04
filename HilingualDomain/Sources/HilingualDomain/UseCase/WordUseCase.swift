//
//  DefaultWordBookUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/13/25.
//

import Combine

public protocol WordBookUseCase {
    func execute(sort: SortOption) -> AnyPublisher<[(date: String, items: [WordEntity])], Error>
    func getWordDetail(id: Int) -> AnyPublisher<WordEntity, Error>
}

public final class DefaultWordBookUseCase: WordBookUseCase {

    private let repository: WordBookRepository

    public init(repository: WordBookRepository) {
        self.repository = repository
    }

    public func execute(sort: SortOption) -> AnyPublisher<[(date: String, items: [WordEntity])], Error> {
        return repository.fetchWords(sort: sort)
    }
    public func getWordDetail(id: Int) -> AnyPublisher<WordEntity, Error> {
        return repository.fetchWordDetail(id: id)
    }
}
