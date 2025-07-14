//
//  DiaryDetailRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Combine

public protocol DiaryDetailRepository {
    func fetchDiaryDetail(diaryId: Int64) -> AnyPublisher<DiaryDetailEntity, Error>
}
