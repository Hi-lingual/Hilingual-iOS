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
    
    public var headers: [String : String]? {
        let header = [
            "Content-Type": "application/json",
            //TODO: - 토큰 변경
            "Authorization": "Bearer \(NetworkEnvironment.shared.token)"
        ]
        return header
    }

    public var sampleData: Data {
        return Data()
    }
}
