//
//  DefaultPublishDiaryRepository.swift
//  HilingualData
//
//  Created by 진소은 on 8/27/25.
//

import Combine

import HilingualNetwork
import HilingualDomain

public final class DefaultPublishDiaryRepository: PublishDiaryRepository {
    private let service: PublishDiaryService
    
    public init(service: PublishDiaryService) {
        self.service = service
    }
    
    public func publishDiary(diaryId: Int, isPublished: Bool) -> AnyPublisher<Void, Error> {
        return service.publishDiary(diaryId: diaryId, isPublished: isPublished)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
