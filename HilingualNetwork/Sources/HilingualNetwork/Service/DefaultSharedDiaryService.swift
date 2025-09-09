//
//  DefaultSharedDiaryService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 9/7/25.
//

import Foundation
import Combine

public protocol SharedDiaryService {
    func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryResponseDTO, Error>
    func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error>
}

public final class DefaultSharedDiaryService: BaseService<SharedDiaryAPI>, SharedDiaryService {
    public func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryResponseDTO, Error> {
        return request(.fetchSharedDiaryProfile(diaryId: diaryId), as: SharedDiaryResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error> {
        return requestPlain(.toggleLike(diaryId: diaryId, isLiked: isLiked))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
