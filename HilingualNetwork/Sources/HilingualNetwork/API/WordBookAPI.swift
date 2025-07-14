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
    case toggleBookmark(phraseId: Int, isBookmarked: Bool)
}

extension WordBookAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchWordList:
            return "/api/v1/words"
        case .fetchWordDetail(let id):
            return "/api/v1/words/\(id)"
        case .toggleBookmark(let phraseId, _):
            return "/api/v1/words/\(phraseId)/bookmark"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchWordList, .fetchWordDetail:
            return .get
        case .toggleBookmark:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .fetchWordList(let sort):
            return .requestParameters(parameters: ["sort": sort], encoding: URLEncoding.queryString)

        case .fetchWordDetail:
            return .requestPlain

        case .toggleBookmark(_, let isBookmarked):
            let body = BookmarkRequestDTO(isBookmarked: isBookmarked)
            return .requestJSONEncodable(body)
        }
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
