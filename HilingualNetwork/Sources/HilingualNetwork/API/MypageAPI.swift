//
//  MypageAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/9/25.
//

import Foundation
import Moya

public enum MypageAPI {
    case fetchMyProfile
}

extension MypageAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .fetchMyProfile:
            return "/users/mypage/info"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        return .requestPlain
    }
}
