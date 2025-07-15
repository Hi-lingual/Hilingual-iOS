//
//  BaseTargetType.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Moya

public protocol BaseTargetType: TargetType {}

extension BaseTargetType {

    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }

    public var headers: [String: String]? {
        var baseHeaders: [String: String] = [
            "Content-Type": "application/json"
        ]

        let accessToken = UserDefaultHandler.accessToken
        if !accessToken.isEmpty {
            baseHeaders["Authorization"] = "Bearer \(accessToken)"
        }

        return baseHeaders
    }

    public var sampleData: Data {
        return Data()
    }
}
