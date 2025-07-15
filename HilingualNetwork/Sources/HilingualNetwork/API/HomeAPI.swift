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

extension HomeAPI: TargetType {
    
    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }

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

    public var headers: [String: String]? {
        switch self {
        case .getUserInfo:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHandler.accessToken)"
            ]
        }
    }

    public var sampleData: Data {
        return Data()
    }
}
