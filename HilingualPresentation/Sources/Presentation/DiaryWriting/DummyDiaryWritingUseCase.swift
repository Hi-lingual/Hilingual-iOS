//
//  DummyDiaryWritingUseCase.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/31/25.
//

import Foundation
import Combine
import HilingualDomain

public class DummyDiaryWritingUseCase: DiaryWritingUseCase {
    public init() {}
    
    public func postDiaryWriting(_ entity: DiaryWritingEntity) -> AnyPublisher<DiaryWritingResponseEntity, Error> {
        let mockResponse = DiaryWritingResponseEntity(diaryId: 123)

        return Just(mockResponse)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
