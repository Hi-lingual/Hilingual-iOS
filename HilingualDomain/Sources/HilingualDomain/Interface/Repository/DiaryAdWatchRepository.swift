//
//  DiaryAdWatchRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 3/20/26.
//

import Combine

public protocol DiaryAdWatchRepository {
    func patchAdWatch(diaryId: Int) -> AnyPublisher<Void, Error>
}
