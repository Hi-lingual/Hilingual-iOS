//
//  WidgetStreakResponseDTO.swift
//  HilingualNetwork
//
//  Created by youngseo on 8/23/26.
//

import Foundation

public struct WidgetStreakResponseDTO: Decodable {
    public let streak: Int
    public let recentDays: [WidgetStreakRecentDayDTO]
}

public struct WidgetStreakRecentDayDTO: Decodable {
    public let date: String
    public let dayOfWeek: String
    public let isWritten: Bool
}
