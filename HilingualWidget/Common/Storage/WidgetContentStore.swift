//
//  WidgetContentStore.swift
//  HilingualWidget
//
//  Created by youngseo on 8/23/26.
//

import Foundation

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

    static func loadTopic() -> TopicSnapshot? {
        load(TopicSnapshot.self, forKey: topicKey)
    }

    static func loadStreak() -> StreakSnapshot? {
        load(StreakSnapshot.self, forKey: streakKey)
    }

    private static func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults(suiteName: appGroupIdentifier)?.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(type, from: data)
    }
}
