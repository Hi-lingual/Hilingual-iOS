//
//  RecommendedUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/16/25.
//

import Combine

public protocol RecommendedUseCase {
    func fetchRecommendedVoca(diaryId: Int) -> AnyPublisher<[RecommendedVocaEntity.Phrase], Error>
}

public final class DefaultRecommendedUseCase: RecommendedUseCase {
    private let repository: RecommendedVocaRepository
    
    public init(repository: RecommendedVocaRepository) {
        self.repository = repository
    }
    
    public func fetchRecommendedVoca(diaryId: Int) -> AnyPublisher<[RecommendedVocaEntity.Phrase], Error> {
        return repository.fetchRecommendedVoca(diaryId: diaryId)
    }
}
