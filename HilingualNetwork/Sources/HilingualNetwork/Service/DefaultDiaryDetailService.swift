//
//  DiaryDetailService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

import Moya
import Combine

public protocol DiaryDetailService {
    func fetchDiaryDetail(diaryId: Int) -> AnyPublisher<DiaryDetailResponseDTO, Error>
}

public final class DefaultDiaryDetailService: BaseService<DiaryDetailAPI>, DiaryDetailService {
    public func fetchDiaryDetail(diaryId: Int) -> AnyPublisher<DiaryDetailResponseDTO, Error> {
        return request(.fetchDiaryDetail(diaryId: diaryId), as: DiaryDetailResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
