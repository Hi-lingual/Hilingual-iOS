//
//  HomeAPI.swift
//  Hilingual
//
//  Created by 조영서 on 7/16/25.
//

import Foundation
import Moya

public enum HomeAPI {
    case getUserInfo
    case getMonthInfo(year: Int, month: Int)
    case getDiaryInfo(date: String)
    case getTopic(date: String)
    case publishDiary(diaryId: Int)
    case unpublishDiary(diaryId: Int)
    case deleteDiary(diaryId: Int)
}

extension HomeAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .getUserInfo:
            return "/users/home/info"
        case .getMonthInfo:
            return "/home/calendar/month"
        case let .getDiaryInfo(date):
            return "/home/calendar/\(date)"
        case let .getTopic(date):
            return "/home/calendar/\(date)/topic"
        case let .publishDiary(diaryId):
            return "/diaries/\(diaryId)/publish"
        case let .unpublishDiary(diaryId):
            return "/diaries/\(diaryId)/unpublish"
        case let .deleteDiary(diaryId):
            return "/diaries/\(diaryId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getMonthInfo,
             .getDiaryInfo,
             .getTopic:
            return .get
        case .publishDiary,
                .unpublishDiary:
            return .patch
        case .deleteDiary:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case let .getMonthInfo(year, month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: OrderedURLEncoding()
            )
        case .getDiaryInfo, .getTopic:
            return .requestPlain
        case .publishDiary, .unpublishDiary, .deleteDiary:
            return .requestPlain
        }
    }
}
