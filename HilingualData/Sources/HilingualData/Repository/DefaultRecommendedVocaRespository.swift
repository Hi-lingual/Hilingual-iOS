//
//  DefaultRecommendedVocaRespository.swift
//  HilingualData
//
//  Created by 진소은 on 7/16/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultRecommendedVocaRepository: RecommendedVocaRepository {
    
    private let service: RecommendedVocaService
    
    public init(service: RecommendedVocaService) {
        self.service = service
    }
    
    public func fetchRecommendedVoca(diaryId: Int) -> AnyPublisher<[RecommendedVocaEntity.Phrase], Error> {
        return service.fetchRecommendedVoca(diaryId: diaryId)
            .map { dto -> [RecommendedVocaEntity.Phrase] in
                dto.data.phraseList.map {
                    RecommendedVocaEntity.Phrase(
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
