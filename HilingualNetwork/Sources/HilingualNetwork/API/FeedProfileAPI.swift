//
//  FeedProfileAPI.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/22/25.
//

import Foundation
import Moya

public enum FeedProfileAPI {
    case fetchSharedFeed(targetUserId: Int64)
    case fetchLikedFeed(targetUserId: Int64)
    case fetchProfileInfo(targetUserId: Int64)
}

extension FeedProfileAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchSharedFeed(let targetUserId):
            return "/feed/profiles/\(targetUserId)/diaries/shared"
        case .fetchLikedFeed(let targetUserId):
            return "/feed/profiles/\(targetUserId)/diaries/liked"
        case .fetchProfileInfo(let targetUserId):
            return "/feed/profiles/\(targetUserId)"
        }
    }
    
    public var method: Moya.Method { .get }
    public var task: Task { .requestPlain }
}
