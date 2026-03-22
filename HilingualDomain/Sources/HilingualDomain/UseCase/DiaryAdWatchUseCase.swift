//
//  DiaryAdWatchUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 3/20/26.
//

import Combine

public protocol DiaryAdWatchUseCase {
    func execute(diaryId: Int) -> AnyPublisher<Void, Error>
}

public final class DefaultDiaryAdWatchUseCase: DiaryAdWatchUseCase {
    private let repository: DiaryAdWatchRepository

    public init(repository: DiaryAdWatchRepository) {
        self.repository = repository
    }

    public func execute(diaryId: Int) -> AnyPublisher<Void, Error> {
        return repository.patchAdWatch(diaryId: diaryId)
    }
}
