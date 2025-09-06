//
//  MyPageAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/7/25.
//

import Moya

public enum MyPageAPI {
    case fetchBlockUserList
}

extension MyPageAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchBlockUserList:
            return "/users/mypage/blocks"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchBlockUserList:
            return .get
        }
    }

    public var task: Task {
        return .requestPlain
    }
}
