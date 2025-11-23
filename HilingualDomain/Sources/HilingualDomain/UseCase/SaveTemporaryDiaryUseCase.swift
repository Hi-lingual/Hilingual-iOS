//
//  SaveTemporaryDiaryUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 11/13/25.
//

import Combine

public protocol SaveTemporaryDiaryUseCase {
    func execute(_ draft: TemporaryDiaryEntity) -> AnyPublisher<Void, Error>
}

public final class DefaultSaveTemporaryDiaryUseCase: SaveTemporaryDiaryUseCase {
    private let temporaryDiaryRepository: TemporaryDiaryRepository

    public init(temporaryDiaryRepository: TemporaryDiaryRepository) {
        self.temporaryDiaryRepository = temporaryDiaryRepository
    }

    public func execute(_ draft: TemporaryDiaryEntity) -> AnyPublisher<Void, Error> {
        return temporaryDiaryRepository.save(draft)
    }
}
