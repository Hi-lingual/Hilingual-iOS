//
//  HomeAdWatchAPI.swift
//  HilingualNetwork
//
//  Created by youngseo on 6/18/26.
//

import Foundation
import Moya

public enum HomeAdWatchAPI {
    case postAdWatch(HomeAdWatchRequestDTO)
}

extension HomeAdWatchAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .postAdWatch:
            return "/v1/users/me/recovery-ticket"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case .postAdWatch(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }
}
