//
//  DiaryWritingRepository.swift
//  HilingualDomain
//
//  Created by 신혜연 on 7/16/25.
//

import Combine

public protocol DiaryWritingRepository {
    func postDiaryWriting(_ entity: DiaryWritingEntity) -> AnyPublisher<DiaryWritingResponseEntity, Error>
}
