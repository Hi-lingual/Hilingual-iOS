//
//  FetchTemporaryDiaryUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 11/14/25.
//

import Combine
import Foundation

public protocol FetchTemporaryDiaryUseCase {
    func execute(_ date: Date) -> AnyPublisher<TemporaryDiaryEntity?, Error>
}

public final class DefaultFetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase {
    private let temporaryDiaryRepository: TemporaryDiaryRepository
    public init(temporaryDiaryRepository: TemporaryDiaryRepository) { self.temporaryDiaryRepository = temporaryDiaryRepository }

    public func execute(_ date: Date) -> AnyPublisher<TemporaryDiaryEntity?, Error> {
        temporaryDiaryRepository.fetch(by: date)
    }
}
