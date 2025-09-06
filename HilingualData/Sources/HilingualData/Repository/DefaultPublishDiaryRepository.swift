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
    private let service: DiaryControlService

    public init(service: DiaryControlService) {
        self.service = service
    }
    
    public func publishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.publishDiary(diaryId: diaryId)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func unpublishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.unpublishDiary(diaryId: diaryId)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
