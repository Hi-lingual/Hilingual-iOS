//
//  WidgetContentStore.swift
//  Hilingual
//
//  Created by youngseo on 8/23/26.
//

import Foundation
import HilingualDomain

enum WidgetContentStore {
    private static let appGroupIdentifier = "group.com.Hilingual.Hilingual"
    private static let topicKey = "widget.topic.snapshot"
    private static let streakKey = "widget.streak.snapshot"

    struct TopicSnapshot: Codable {
        let topicEn: String?
        let isWrittenToday: Bool?
        let isFailed: Bool
        let updatedAt: Date
    }

    struct StreakSnapshot: Codable {
        let isLoggedIn: Bool
        let streak: Int
        let recentDays: [RecentDaySnapshot]
        let updatedAt: Date
    }

    struct RecentDaySnapshot: Codable {
        let dayOfWeek: String
        let isWritten: Bool
    }

    static func saveTopic(_ entity: WidgetTopicEntity, updatedAt: Date = Date()) {
        let snapshot = TopicSnapshot(
            topicEn: entity.topicEn,
            isWrittenToday: entity.isWrittenToday,
            isFailed: false,
            updatedAt: updatedAt
        )
        save(snapshot, forKey: topicKey)
    }

    static func saveTopicFailure(updatedAt: Date = Date()) {
        let snapshot = TopicSnapshot(
            topicEn: nil,
            isWrittenToday: false,
            isFailed: true,
            updatedAt: updatedAt
        )
        save(snapshot, forKey: topicKey)
    }

    static func saveStreak(_ entity: WidgetStreakEntity, updatedAt: Date = Date()) {
        let snapshot = StreakSnapshot(
            isLoggedIn: true,
            streak: entity.streak,
            recentDays: entity.recentDays.map {
                RecentDaySnapshot(
                    dayOfWeek: $0.dayOfWeek,
                    isWritten: $0.isWritten
                )
            },
            updatedAt: updatedAt
        )
        save(snapshot, forKey: streakKey)
    }

    static func saveLoggedOutStreak(updatedAt: Date = Date()) {
        let snapshot = StreakSnapshot(
            isLoggedIn: false,
            streak: 0,
            recentDays: loggedOutRecentDays,
            updatedAt: updatedAt
        )
        save(snapshot, forKey: streakKey)
    }

    private static let loggedOutRecentDays: [RecentDaySnapshot] = [
        RecentDaySnapshot(dayOfWeek: "MON", isWritten: false),
        RecentDaySnapshot(dayOfWeek: "TUE", isWritten: false),
        RecentDaySnapshot(dayOfWeek: "WED", isWritten: false),
        RecentDaySnapshot(dayOfWeek: "THU", isWritten: false),
        RecentDaySnapshot(dayOfWeek: "FRI", isWritten: false)
    ]

    private static func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults(suiteName: appGroupIdentifier)?.set(data, forKey: key)
    }
}
