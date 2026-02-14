//
//  MockPublishDiaryService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/27/25.
//

import Combine

public protocol PublishDiaryService {
    func publishDiary(diaryId: Int, isPublished: Bool) -> AnyPublisher<PublishDiaryResponseDTO, Error>
}

public final class MockPublishDiaryService: PublishDiaryService {
    public init() {}
    
    private var publishStates: [Int: Bool] = [:]
    
    public func publishDiary(diaryId: Int, isPublished: Bool) -> AnyPublisher<PublishDiaryResponseDTO, Error> {
        publishStates[diaryId] = isPublished
        
        let status = isPublished ? "공개" : "비공개"
        let response = PublishDiaryResponseDTO(
            code: 200,
            data: nil,
            message: "일기 \(diaryId)가 \(status)되었습니다."
        )
        
        print("Mock publishDiary called → diaryId: \(diaryId), isPublished: \(isPublished)")
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
