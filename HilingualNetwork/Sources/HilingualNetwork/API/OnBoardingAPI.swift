//
//  File.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation
import Moya

public enum OnBoardingAPI {
    case checkNickname(nickname: String)
}

extension OnBoardingAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .checkNickname:
            return "/users/profile"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.default
            )
        }
    }
}
