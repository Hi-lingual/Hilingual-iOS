//
//  DefaultRecommendedVocaService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/16/25.
//

import Foundation

import Moya
import Combine

public protocol RecommendedExpressionService {
    func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<RecommendedExpressionResponseDTO, Error>
}

public final class DefaultRecommendedExpressionService: BaseService<RecommendedExpressionAPI>, RecommendedExpressionService {
    public func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<RecommendedExpressionResponseDTO, Error> {
        return request(.fetchRecommendedExpression(diaryId: diaryId), as: RecommendedExpressionResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
