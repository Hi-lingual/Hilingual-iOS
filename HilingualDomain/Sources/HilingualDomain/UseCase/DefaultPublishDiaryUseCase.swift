//
//  DefaultPublishDiaryUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/27/25.
//

import Combine

public protocol PublishDiaryUseCase {
    func execute(diaryId: Int, isPublished: Bool) -> AnyPublisher<Void, Error>
}

public final class DefaultPublishDiaryUseCase: PublishDiaryUseCase {
    private let repository: PublishDiaryRepository
    
    public init(repository: PublishDiaryRepository) {
        self.repository = repository
    }
    
    public func execute(diaryId: Int, isPublished: Bool) -> AnyPublisher<Void, Error> {
        return repository.publishDiary(diaryId: diaryId, isPublished: isPublished)
    }
}
