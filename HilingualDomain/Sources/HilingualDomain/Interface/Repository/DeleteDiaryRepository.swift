//
//  DeleteDiaryRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/27/25.
//

import Combine

public protocol DeleteDiaryRepository {
    func deleteDiary(diaryId: Int) -> AnyPublisher<Void, Error>
}
