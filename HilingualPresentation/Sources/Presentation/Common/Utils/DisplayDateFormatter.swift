//
//  DisplayDateFormatter.swift
//  HilingualPresentation
//
//  Created by 성현주 on 4/25/26.
//

import Foundation

public enum DisplayDateFormatter {
    // ISO8601 UTC 문자열을 알림 화면 표시 형식인 "yyyy.MM.dd"로 변환합니다.
    // 예: "2026-03-28T07:01:49Z" -> "2026.03.28"
    public static func notificationDate(utcString: String?, fallback: String) -> String {
        guard let utcString,
              let date = parseISO8601(utcString)
        else {
            return fallback
        }

        return format(date, as: "yyyy.MM.dd")
    }

    // API 날짜 문자열 "yyyy-MM-dd"를 일기 상세 화면 표시 형식인 "M월 d일 EEEE"로 변환합니다.
    // 예: "2026-04-12" -> "4월 12일 일요일"
    public static func diaryDetailDate(apiDate: String) -> String {
        guard let date = parseAPIDate(apiDate) else {
            return apiDate
        }

        return format(date, as: "M월 d일 EEEE")
    }

    // topic 조회 등 서버 전송용 날짜를 "yyyy-MM-dd"로 정규화합니다.
    // 이미 API 포맷이면 그대로 반환하고, 구형 표시 문자열만 fallback 변환합니다.
    public static func normalizedAPIDate(_ value: String) -> String {
        if parseAPIDate(value) != nil {
            return value
        }

        return value.toAPIDate() ?? value
    }

    // 단어 상세의 저장 출처 문구를 생성합니다.
    // - savedRoot == 1: writtenDate를 "yy.MM.dd 일기에서 저장됨"으로 포맷
    // - savedRoot == 2: "피드에서 저장됨"
    // - 그 외: 서버의 writtenFrom 값을 그대로 fallback
    public static func wordSavedSource(writtenFrom: String?, writtenDate: String?, savedRoot: Int?) -> String {
        guard let savedRoot else {
            return writtenFrom ?? ""
        }

        switch savedRoot {
        case 1:
            guard let writtenDate,
                  let date = parseAPIDate(writtenDate) else {
                return writtenFrom ?? ""
            }
            return "\(format(date, as: "yy.MM.dd")) 일기에서 저장됨"
        case 2:
            return "피드에서 저장됨"
        default:
            return writtenFrom ?? ""
        }
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

    private static func format(_ date: Date, as format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
