//
//  HomeAPI.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya

public enum HomeAPI {
    case getUserInfo
}

extension HomeAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .getUserInfo:
            return "/users/info"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
}
