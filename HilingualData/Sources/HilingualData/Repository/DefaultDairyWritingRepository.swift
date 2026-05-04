//
//  DefaultDairyWritingRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation
import Combine

import HilingualNetwork
import HilingualDomain

public final class DefaultDiaryWritingRepository: DiaryWritingRepository {
    
    private let service: DiaryWritingService
    
    public init(service: DiaryWritingService) {
        self.service = service
    }
    
    public func postDiaryWriting(_ entity: DiaryWritingEntity) -> AnyPublisher<DiaryWritingResponseEntity, Error> {
        let requestDTO = DiaryWritingRequestDTO(
            originalText: entity.originalText,
            date: entity.date,
            fileKey: entity.image?.fileKey
        )
        
        return service.postDiaryWriting(requestDTO: requestDTO)
            .map { responseDTO in
                DiaryWritingResponseEntity(
                    diaryId: responseDTO.data.diaryId,
                    isAdWatched: responseDTO.data.isAdWatched
                )
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
