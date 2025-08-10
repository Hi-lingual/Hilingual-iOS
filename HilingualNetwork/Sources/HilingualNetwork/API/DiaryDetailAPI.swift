//
//  DiaryDetailAPI.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/16/25.
//

import Foundation
import Moya

public enum DiaryDetailAPI {
    case fetchDiaryDetail(diaryId: Int)
    case fetchFeedback(diaryId: Int)
    case fetchRecommendedExpression(diaryId: Int)
}

extension DiaryDetailAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchDiaryDetail(let diaryId):
            return "diaries/\(diaryId)"
        case .fetchFeedback(let diaryId):
            return "/diaries/\(diaryId)/feedbacks"
        case .fetchRecommendedExpression(let diaryId):
            return "diaries/\(diaryId)/recommended"
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchDiaryDetail:
            return .get
        case .fetchFeedback:
            return .get
        case .fetchRecommendedExpression:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchDiaryDetail:
            return .requestPlain
        case .fetchFeedback:
            return .requestPlain
        case .fetchRecommendedExpression:
            return .requestPlain
        }
    }
}
