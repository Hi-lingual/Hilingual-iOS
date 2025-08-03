//
//  RecommendedVocaRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/16/25.
//

import Combine

public protocol RecommendedExpressionRepository {
    func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<[RecommendedExpressionEntity.Phrase], Error>
}
