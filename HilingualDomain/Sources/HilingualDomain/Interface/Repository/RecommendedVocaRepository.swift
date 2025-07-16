//
//  RecommendedVocaRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/16/25.
//

import Combine

public protocol RecommendedVocaRepository {
    func fetchRecommendedVoca(diaryId: Int) -> AnyPublisher<[RecommendedVocaEntity.Phrase], Error>
}
