//
//  SharedDiaryProfileAPI.swift
//  HilingualNetwork
//
//  Created by 진소은 on 9/6/25.
//

import Foundation
import Moya

public enum SharedDiaryAPI {
    case fetchSharedDiaryProfile(diaryId: Int)
    case toggleLike(diaryId: Int, isLiked: Bool)
}

extension SharedDiaryAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchSharedDiaryProfile(let diaryId):
            return "feed/\(diaryId)/users/profiles"
        case .toggleLike(let diaryId, _):
            return "feed/likes/\(diaryId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchSharedDiaryProfile:
            return .get
        case .toggleLike:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchSharedDiaryProfile:
            return .requestPlain
        case .toggleLike(_, let isLiked):
            let body = LikeRequestDTO(isLiked: isLiked)
            return .requestJSONEncodable(body)
        }
        
    }
}
