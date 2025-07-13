//
//  WordBookAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/13/25.
//

import Moya

public enum WordBookAPI {
    case fetchWordList(sort: Int)
    case fetchWordDetail(id: Int)
}

extension WordBookAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchWordList:
            return "/voca"
        case .fetchWordDetail(let id):
            return "/voca/\(id)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        switch self {
        case .fetchWordList(let sort):
            return .requestParameters(parameters: ["sort": sort], encoding: URLEncoding.queryString)
        case .fetchWordDetail:
            return .requestPlain
        }
    }
}
