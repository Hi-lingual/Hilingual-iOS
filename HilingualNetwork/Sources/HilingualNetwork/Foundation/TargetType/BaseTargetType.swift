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
        let baseHeaders: [String: String] = [
            "Content-Type": "application/json",
            "X-Timezone": TimeZone.autoupdatingCurrent.identifier
        ]

//        let accessToken = UserDefaultHandler.accessToken
//        if !accessToken.isEmpty {
//            baseHeaders["Authorization"] = "Bearer \(accessToken)"
//        }

        return baseHeaders
    }

    public var sampleData: Data {
        return Data()
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
