//
//  DeleteDiaryUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/27/25.
//

import Combine

public protocol DeleteDiaryUseCase {
    func execute(diaryId: Int) -> AnyPublisher<Void, Error>
}

public final class DefaultDeleteDiaryUseCase: DeleteDiaryUseCase {
    private let repository: DeleteDiaryRepository
    
    public init(repository: DeleteDiaryRepository) {
        self.repository = repository
    }
    
    public func execute(diaryId: Int) -> AnyPublisher<Void, Error> {
        return repository.deleteDiary(diaryId: diaryId)
    }
}
