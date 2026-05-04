//
//  DiaryWritingAPI.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation
import Moya

public enum DiaryWritingAPI {
    case postDiaryWriting(DiaryWritingRequestDTO)
}

extension DiaryWritingAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .postDiaryWriting:
            return "/diaries"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case .postDiaryWriting(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }

    public var sampleData: Data {
        return Data()
    }
}
