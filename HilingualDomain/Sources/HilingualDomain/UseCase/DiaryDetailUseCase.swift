//
//  DiaryDetailUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Combine

public protocol DiaryDetailUseCase {
    func fetchDiaryDetail(diaryId: Int) -> AnyPublisher<DiaryDetailEntity, Error>
}

public final class DefaultDiaryDetailUseCase: DiaryDetailUseCase {
    private let repository: DiaryDetailRepository
    
    public init(repository: DiaryDetailRepository) {
        self.repository = repository
    }

    public func fetchDiaryDetail(diaryId: Int) -> AnyPublisher<DiaryDetailEntity, Error> {
        return repository.fetchDiaryDetail(diaryId: 28)
    }
}
