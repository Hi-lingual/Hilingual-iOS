//
//  DefaultDiaryDetailRepository.swift
//  HilingualData
//
//  Created by 진소은 on 7/9/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultDiaryDetailRepository: DiaryDetailRepository {
    
    private var service: DiaryDetailService
    
    public init(service: DiaryDetailService) {
        self.service = service
    }
    
    public func fetchDiaryDetail(diaryId: Int) -> AnyPublisher<DiaryDetailEntity, Error> {
        return service.fetchDiaryDetail(diaryId: diaryId)
            .tryMap { dto -> DiaryDetailEntity in
                guard let data = dto.data else {
                    throw NetworkError.decoding
                }
                let diffRanges: [DiaryDetailEntity.DiffRange] = data.diffRanges.map {
                    DiaryDetailEntity.DiffRange(
                        start: $0.start,
                        end: $0.end,
                        correctedText: $0.correctedText
                    )
                }
                
                return DiaryDetailEntity(
                    date: data.date,
                    image: data.imageUrl ?? "",
                    originalText: data.originalText,
                    rewriteText: data.rewriteText,
                    diffRanges: diffRanges,
                    isPublished: data.isPublished,
                    isAdWatched: data.isAdWatched
                )
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
