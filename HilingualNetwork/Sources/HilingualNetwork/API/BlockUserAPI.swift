//
//  BlockUserAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/7/25.
//

import Moya

public enum BlockUserAPI {
    case fetchBlockUserList
    case blockUser(userId: Int)
}

extension BlockUserAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchBlockUserList:
            return "/users/mypage/blocks"
        case .blockUser(let userId):
            return "/users/\(userId)/block"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchBlockUserList:
            return .get
        case .blockUser:
            return .post
        }
    }

    public var task: Task {
        return .requestPlain
    }
}
