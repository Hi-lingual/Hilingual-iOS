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
}

public final class DefaultDiaryWritingService: BaseService<DiaryWritingAPI>, DiaryWritingService {
    public func postDiaryWriting(requestDTO: DiaryWritingRequestDTO) -> AnyPublisher<DiaryWritingResponseDTO, Error> {
//        #if DEBUG
//        print("[DEBUG] DiaryWritingService - Mock 응답 반환 중")
//        print("originalText: \(requestDTO.originalText)")
//        print("date: \(requestDTO.date)")
//        print("imageFile size: \(requestDTO.imageFile.count) bytes")
//
//        let mockResponse = DiaryWritingResponseDTO(
//            code: 200,
//            data: DiaryIdDTO(id: 0),
//            message: "디버그용 mock response입니다"
//        )
//
//        return Just(mockResponse)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        #else
        return request(.postDiaryWriting(requestDTO), as: DiaryWritingResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
//        #endif
    }
}
