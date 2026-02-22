//
//  DefaultDeleteDiaryRepository.swift
//  HilingualData
//
//  Created by 진소은 on 8/27/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultDeleteDiaryRepository: DeleteDiaryRepository {
    private let service: DiaryControlService
    
    public init(service: DiaryControlService) {
        self.service = service
    }
    
    public func deleteDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.deleteDiary(diaryId: diaryId)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
