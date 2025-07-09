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
    func fetchDiaryDetail(diaryId: Int64) -> AnyPublisher<DiaryDetailDTO, Error>
}

// TODO: - API 연동 시 구현

public final class DefaultDiaryDetailService: DiaryDetailService {
    public func fetchDiaryDetail(diaryId: Int64) -> AnyPublisher<DiaryDetailDTO, Error> {
        fatalError("DiaryDetailService 구현X")
    }
}
