//
//  AuthAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Moya

public enum AuthAPI {
    case socialLogin(provider: String, providerToken: String)
}

extension AuthAPI: NoAuthorizeTargetType {

    public var path: String {
        return "/auth/login"
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case let .socialLogin(provider, _):
            return .requestJSONEncodable(["provider": provider])
        }
    }

    public var headers: [String: String]? {
        switch self {
        case let .socialLogin(_, token):
            return [
                "Content-Type": "application/json",
                "Provider-Token": token
            ]
        }
    }
}
