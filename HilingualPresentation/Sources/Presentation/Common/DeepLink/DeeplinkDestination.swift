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

    public var pushNotificationAnalytics: (
        type: AnalyticsEvent.NotificationType,
        page: AnalyticsEvent.Page
    ) {
        switch self {
        case .diaryDetail: return (.diaryEmpathy, .postedDiary)
        case .userProfile: return (.friendFollow, .userProfile)
        case .home: return (.reminderDaily, .home)
        }
    }
}
