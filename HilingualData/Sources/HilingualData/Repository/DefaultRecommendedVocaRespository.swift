//
//  DefaultRecommendedVocaRespository.swift
//  HilingualData
//
//  Created by 진소은 on 7/16/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultRecommendedExpressionRepository: RecommendedExpressionRepository {
    
    private let service: RecommendedExpressionService
    
    public init(service: RecommendedExpressionService) {
        self.service = service
    }
    
    public func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<[RecommendedExpressionEntity.Phrase], Error> {
        return service.fetchRecommendedExpression(diaryId: diaryId)
            .map { dto -> [RecommendedExpressionEntity.Phrase] in
                dto.data.phraseList.map {
                    RecommendedExpressionEntity.Phrase(
                        phraseId: $0.phraseId,
                        phraseType: $0.phraseType,
                        phrase: $0.phrase,
                        explanation: $0.explanation,
                        reason: $0.reason,
                        isBookmarked: $0.isBookmarked
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
