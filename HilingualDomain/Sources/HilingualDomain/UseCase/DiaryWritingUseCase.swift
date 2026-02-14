//
//  DiaryWritingUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 7/16/25.
//

import Combine

public protocol DiaryWritingUseCase {
    func postDiaryWriting(_ entity: DiaryWritingEntity) -> AnyPublisher<DiaryWritingResponseEntity, Error>
}

public final class DefaultDiaryWritingUseCase: DiaryWritingUseCase {
    
    private let repository: DiaryWritingRepository
    
    public init(repository: DiaryWritingRepository) {
        self.repository = repository
    }

    public func postDiaryWriting(_ entity: DiaryWritingEntity) -> AnyPublisher<DiaryWritingResponseEntity, Error> {
        return repository.postDiaryWriting(entity)
    }
}
