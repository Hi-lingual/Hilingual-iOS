//
//  BaseTargetType.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya

public protocol BaseTargetType: TargetType {}

extension BaseTargetType{

    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }

    public var sampleData: Data {
        return Data()
    }
}
