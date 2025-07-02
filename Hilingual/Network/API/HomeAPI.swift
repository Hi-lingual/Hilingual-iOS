//
//  HomeAPI.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Moya

enum HomeAPI {
    case getRate
}

extension HomeAPI: BaseTargetType {
    var path: String {
        return "/money"
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }
}
