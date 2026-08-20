//
//  DiaryWritingService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation
import Combine

public protocol DiaryWritingService {
    func postDiaryWriting(requestDTO: DiaryWritingRequestDTO) -> AnyPublisher<DiaryWritingResponseDTO, Error>
    func postDiaryRecovery(requestDTO: DiaryRecoveryRequestDTO) -> AnyPublisher<DiaryRecoveryResponseDTO, Error>
}

public final class DefaultDiaryWritingService: BaseService<DiaryWritingAPI>, DiaryWritingService {
    public func postDiaryWriting(requestDTO: DiaryWritingRequestDTO) -> AnyPublisher<DiaryWritingResponseDTO, Error> {
        return request(.postDiaryWriting(requestDTO), as: DiaryWritingResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func postDiaryRecovery(requestDTO: DiaryRecoveryRequestDTO) -> AnyPublisher<DiaryRecoveryResponseDTO, Error> {
        return request(.postDiaryRecovery(requestDTO), as: DiaryRecoveryResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
