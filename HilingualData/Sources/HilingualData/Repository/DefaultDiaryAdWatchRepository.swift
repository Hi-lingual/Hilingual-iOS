//
//  DefaultDiaryAdWatchRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 3/20/26.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultDiaryAdWatchRepository: DiaryAdWatchRepository {
    private let service: DiaryAdWatchService

    public init(service: DiaryAdWatchService) {
        self.service = service
    }

    public func patchAdWatch(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.patchAdWatch(diaryId: diaryId)
            .eraseToAnyPublisher()
    }
}
