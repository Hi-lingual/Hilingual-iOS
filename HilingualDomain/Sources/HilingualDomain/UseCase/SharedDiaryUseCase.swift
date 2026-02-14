//
//  SharedDiaryUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/26/25.
//

import Combine

public protocol SharedDiaryUseCase {
    func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryEntity, Error>
}

public final class DefaultSharedDiaryUseCase: SharedDiaryUseCase {
    private let repository: SharedDiaryRepository
    
    public init(repository: SharedDiaryRepository) {
        self.repository = repository
    }
    
    public func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryEntity, Error> {
        return repository.fetchSharedDiary(diaryId: diaryId)
    }
}
