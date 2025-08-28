//
//  MockDeleteDiaryService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/27/25.
//

import Combine

public protocol DeleteDiaryService {
    func deleteDiary(diaryId: Int) -> AnyPublisher<DeleteDiaryResponseDTO, Error>
}

public final class MockDeleteDiaryService: DeleteDiaryService {
    public init() {}
        
    public func deleteDiary(diaryId: Int) -> AnyPublisher<DeleteDiaryResponseDTO, Error> {
        
        let response = DeleteDiaryResponseDTO(
            code: 200,
            data: nil,
            message: "일기 \(diaryId)가 삭제되었습니다."
        )
                
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
