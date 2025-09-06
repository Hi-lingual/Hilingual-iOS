//
//  PublishDiaryRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/27/25.
//

import Combine

public protocol PublishDiaryRepository {
    func publishDiary(diaryId: Int) -> AnyPublisher<Void, Error>
    func unpublishDiary(diaryId: Int) -> AnyPublisher<Void, Error>
}
