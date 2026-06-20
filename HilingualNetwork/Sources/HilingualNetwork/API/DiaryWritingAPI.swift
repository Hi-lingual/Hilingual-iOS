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
    case postDiaryRecovery(DiaryRecoveryRequestDTO)
}

extension DiaryWritingAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .postDiaryWriting:
            return "/v1/diaries"
        case .postDiaryRecovery:
            return "/v1/diaries/recovery"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .postDiaryWriting, .postDiaryRecovery:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case .postDiaryWriting(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        case .postDiaryRecovery(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }

    public var sampleData: Data {
        return Data()
    }
}
