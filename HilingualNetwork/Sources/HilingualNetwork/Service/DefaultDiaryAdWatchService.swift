//
//  DefaultDiaryAdWatchService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 3/20/26.
//

import Foundation
import Moya
import Combine

public protocol DiaryAdWatchService {
    func patchAdWatch(diaryId: Int) -> AnyPublisher<Void, Error>
}

public final class DefaultDiaryAdWatchService: BaseService<DiaryAdWatchAPI>, DiaryAdWatchService {
    public func patchAdWatch(diaryId: Int) -> AnyPublisher<Void, Error> {
        return requestPlain(.patchAdWatch(diaryId: diaryId))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
