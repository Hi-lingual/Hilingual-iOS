//
//  WordBookAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/13/25.
//

import Moya

public enum WordBookAPI {
    case fetchWordList(sort: Int, unmemorizedOnly: Bool)
    case fetchWordDetail(id: Int)
    case toggleBookmark(phraseId: Int, isBookmarked: Bool)
    case updateMemorization(items: [MemorizationItemDTO])
}

extension WordBookAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchWordList:
            return "/v1/voca"
        case .fetchWordDetail(let id):
            return "/v1/voca/\(id)"
        case .toggleBookmark(let phraseId, _):
            return "/v1/diaries/\(phraseId)"
        case .updateMemorization:
            return "/v1/voca/memorization"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchWordList, .fetchWordDetail:
            return .get
        case .toggleBookmark, .updateMemorization:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .fetchWordList(let sort, let unmemorizedOnly):
            return .requestParameters(
                parameters: ["sort": sort, "unmemorizedOnly": unmemorizedOnly],
                encoding: URLEncoding.queryString
            )

        case .fetchWordDetail:
            return .requestPlain

        case .toggleBookmark(_, let isBookmarked):
            let body = BookmarkRequestDTO(isBookmarked: isBookmarked)
            return .requestJSONEncodable(body)

        case .updateMemorization(let items):
            let body = MemorizationUpdateRequestDTO(items: items)
            return .requestJSONEncodable(body)
        }
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
