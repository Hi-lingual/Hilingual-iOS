//
//  SharedDiaryRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/26/25.
//

import Combine

public protocol SharedDiaryRepository {
    func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryEntity, Error>
    func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error>
}
