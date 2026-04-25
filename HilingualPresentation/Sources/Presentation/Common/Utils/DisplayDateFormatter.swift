//
//  DisplayDateFormatter.swift
//  HilingualPresentation
//
//  Created by 성현주 on 4/25/26.
//

import Foundation

public enum DisplayDateFormatter {
    public static func notificationDate(utcString: String?, fallback: String) -> String {
        guard let utcString,
              let date = parseISO8601(utcString)
        else {
            return fallback
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }

    public static func diaryDetailDate(apiDate: String) -> String {
        guard let date = parseAPIDate(apiDate) else {
            return apiDate
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: date)
    }

    public static func normalizedAPIDate(_ value: String) -> String {
        if parseAPIDate(value) != nil {
            return value
        }

        return value.toAPIDate() ?? value
    }

    public static func wordSavedSource(writtenFrom: String?, fromFeed: Bool?) -> String {
        if fromFeed == true {
            return "피드에서 저장됨"
        }

        guard let writtenFrom, !writtenFrom.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return ""
        }

        guard let date = parseAPIDate(writtenFrom) else {
            return writtenFrom
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = "yy.MM.dd"
        return "\(formatter.string(from: date)) 일기에서 저장됨"
    }

    private static func parseISO8601(_ string: String) -> Date? {
        let fractionalFormatter = ISO8601DateFormatter()
        fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = fractionalFormatter.date(from: string) {
            return date
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string)
    }

    private static func parseAPIDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
}
