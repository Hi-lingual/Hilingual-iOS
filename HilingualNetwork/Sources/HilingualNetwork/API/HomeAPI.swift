//
//  HomeAPI.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Moya

public enum HomeAPI {
    case getRate
}

extension HomeAPI: BaseTargetType {
    public var path: String {
        return "/money"
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        return .requestPlain
    }
}
