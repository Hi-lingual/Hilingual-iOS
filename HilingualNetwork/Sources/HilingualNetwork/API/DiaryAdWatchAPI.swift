//
//  DiaryAdWatchAPI.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 3/20/26.
//

import Foundation
import Moya

public enum DiaryAdWatchAPI {
    case patchAdWatch(diaryId: Int)
}

extension DiaryAdWatchAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .patchAdWatch(let diaryId):
            return "/diaries/\(diaryId)/ad-watch"
        }
    }

    public var method: Moya.Method {
        return .patch
    }

    public var task: Task {
        return .requestPlain
    }
}
