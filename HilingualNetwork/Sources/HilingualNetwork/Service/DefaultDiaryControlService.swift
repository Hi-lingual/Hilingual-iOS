//
//  DefaultDiaryControlService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 9/5/25.
//

import Foundation

import Moya
import Combine

public protocol DiaryControlService {
    func deleteDiary(diaryId: Int) -> AnyPublisher<DeleteDiaryResponseDTO, Error>
    func publishDiary(diaryId: Int) -> AnyPublisher<PublishDiaryResponseDTO, Error>
    func unpublishDiary(diaryId: Int) -> AnyPublisher<PublishDiaryResponseDTO, Error>
}

public final class DefaultDiaryControlService: BaseService<DiaryControlAPI>, DiaryControlService {
    public func deleteDiary(diaryId: Int) -> AnyPublisher<DeleteDiaryResponseDTO, Error> {
        return request(.deleteDiary(diaryId: diaryId), as: DeleteDiaryResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func publishDiary(diaryId: Int) -> AnyPublisher<PublishDiaryResponseDTO, Error> {
        return request(.publishDiary(diaryId: diaryId), as: PublishDiaryResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func unpublishDiary(diaryId: Int) -> AnyPublisher<PublishDiaryResponseDTO, Error> {
        return request(.unpublishDiary(diaryId: diaryId), as: PublishDiaryResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
