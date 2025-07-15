//
//  FeedbackAPI.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/15/25.
//

import Foundation
import Moya

public enum FeedbackAPI {
    case fetchFeedback(diaryId: Int)
}

extension FeedbackAPI: BaseTargetType {
    
    public var path: String {
        switch self {
        case .fetchFeedback(let diaryId):
            print(diaryId)
            return "/diaries/\(diaryId)/feedbacks"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .fetchFeedback:
            return .requestPlain
        }
    }
}
