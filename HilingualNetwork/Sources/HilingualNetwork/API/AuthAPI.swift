//
//  AuthAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Moya

public enum AuthAPI {
    case socialLogin(body: AuthLoginRequestDTO, providerToken: String)
    case refreshToken(refreshToken: String)
}

extension AuthAPI: NoAuthorizeTargetType {
    public var path: String {
        switch self {
        case .socialLogin:
            return "/auth/login"
        case .refreshToken:
            return "/auth/reissue"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case let .socialLogin(body, _):
            return .requestJSONEncodable(body)
        case .refreshToken:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case let .socialLogin(_, providerToken):
            return [
                "Content-Type": "application/json",
                "Provider-Token": providerToken
            ]
        case let .refreshToken(refreshToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(refreshToken)"
            ]
        }
    }
}
