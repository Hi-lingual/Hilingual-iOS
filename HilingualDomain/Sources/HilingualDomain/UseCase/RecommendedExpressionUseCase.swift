//
//  RecommendedUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/16/25.
//

import Combine

public protocol RecommendedExpressionUseCase {
    func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<[RecommendedExpressionEntity.Phrase], Error>
}

public final class DefaultRecommendedExpressionUseCase: RecommendedExpressionUseCase {
    private let repository: RecommendedExpressionRepository
    
    public init(repository: RecommendedExpressionRepository) {
        self.repository = repository
    }
    
    public func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<[RecommendedExpressionEntity.Phrase], Error> {
        return repository.fetchRecommendedExpression(diaryId: diaryId)
    }
}
