//
//  BaseTargetType.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType{

    var baseURL: URL {
        return URL(string: "https://98107e2c-a68e-4e89-bacf-85f13c9a1652.mock.pstmn.io")!
    }

    var headers: [String : String]? {
        let header = [
            "Content-Type": "application/json"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }

    //TODO: - Token 관련 로직 추가
}
