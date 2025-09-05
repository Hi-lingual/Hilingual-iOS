//
//  PresignedURLAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/6/25.
//


import Foundation
import Moya

public enum PresignedURLAPI {
    case getPresignedURL(contentType: String, purpose: String)
    /// "image/jpeg", "PROFILE_UPLOAD"
}

extension PresignedURLAPI: TargetType {
    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }

    public var path: String {
        return "/files/presigned-url"
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case .getPresignedURL(let contentType, let purpose):
            let params: [String: String] = [
                "contentType": contentType,
                "purpose": purpose
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultHandler.accessToken)"
        ]
    }

    public var sampleData: Data {
        return Data()
    }
}
