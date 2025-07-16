//
//  DefaultRecommendedVocaService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/16/25.
//

import Foundation

import Moya
import Combine

public protocol RecommendedVocaService {
    func fetchRecommendedVoca(diaryId: Int) -> AnyPublisher<RecommendedVocaResponseDTO, Error>
}

public final class DefaultRecommendedVocaService: BaseService<RecommendedVocaAPI>, RecommendedVocaService {
    public func fetchRecommendedVoca(diaryId: Int) -> AnyPublisher<RecommendedVocaResponseDTO, Error> {
        return request(.fetchRecommendedVoca(diaryId: diaryId), as: RecommendedVocaResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
