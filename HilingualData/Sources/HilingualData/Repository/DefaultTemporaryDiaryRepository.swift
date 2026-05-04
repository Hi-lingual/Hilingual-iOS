//
//  DefaultTemporaryDiaryRepository.swift
//  HilingualData
//
//  Created by 진소은 on 11/13/25.
//

import Foundation
import Combine
import HilingualDomain

public final class DefaultTemporaryDiaryRepository: TemporaryDiaryRepository {
    private let localDataSource: DiaryDraftLocalDataSource
    private var globalCancellables = Set<AnyCancellable>()

    public init(localDataSource: DiaryDraftLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func save(_ draft: TemporaryDiaryEntity) -> AnyPublisher<Void, Error> {
        localDataSource.save(draft)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func fetchAll() -> AnyPublisher<[TemporaryDiaryEntity], Error> {
        localDataSource.fetchAll()
            .eraseToAnyPublisher()
    }
    
    public func fetch(by date: Date) -> AnyPublisher<TemporaryDiaryEntity?, Error> {
        localDataSource.fetch(by: date)
            .eraseToAnyPublisher()
    }

    public func delete(id: String) -> AnyPublisher<Void, Error> {
        localDataSource.delete(by: id)
            .eraseToAnyPublisher()
    }

    public func deleteAll() -> AnyPublisher<Void, Error> {
        localDataSource.deleteAll()
            .eraseToAnyPublisher()
    }
}
