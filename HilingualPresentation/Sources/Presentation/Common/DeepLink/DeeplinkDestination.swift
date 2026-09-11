//
//  DeeplinkDestination.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import Foundation
import HilingualCore

public enum DeeplinkDestination: Sendable {
    case diaryDetail(diaryId: Int)
    case userProfile(userId: Int)
    case home
    case reminderStreak
    case reminderWinback
    case reminderCustom

    public var pushNotificationAnalytics: (
        type: AnalyticsEvent.NotificationType,
        page: AnalyticsEvent.Page
    )? {
        switch self {
        case .diaryDetail: return (.diaryEmpathy, .postedDiary)
        case .userProfile: return (.friendFollow, .userProfile)
        case .home: return nil
        case .reminderStreak: return (.reminderStreak, .home)
        case .reminderWinback: return (.reminderWinback, .home)
        case .reminderCustom: return (.reminderCustom, .home)
        }
    }
}
