//
//  NoAuthorizeTargetType.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/11/25.
//

import Foundation

import Moya

public protocol NoAuthorizeTargetType: TargetType {}

extension NoAuthorizeTargetType {

    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }

    public var headers: [String : String]? {
        let header = [
            "Content-Type": "application/json"
        ]
        return header
    }

    public var sampleData: Data {
        return Data()
    }
}
