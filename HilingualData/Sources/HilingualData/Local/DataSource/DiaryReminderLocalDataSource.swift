//
//  DiaryReminderLocalDataSource.swift
//  HilingualData
//
//  Created by 신혜연 on 9/5/26.
//

import Foundation
import UserNotifications
import Combine

public final class DiaryReminderLocalDataSource {

    private enum Constant {
        static let identifierPrefix = "diary.reminder.local."
        static let enabledKey = "diaryReminderEnabled"
        static let scheduledWeekdaysKey = "diaryReminderScheduledWeekdays"
        static let hourKey = "diaryReminderHour"
        static let minuteKey = "diaryReminderMinute"
    }

    private let notificationCenter: UNUserNotificationCenter
    private let userDefaults: UserDefaults

    public init(
        notificationCenter: UNUserNotificationCenter = .current(),
        userDefaults: UserDefaults = .standard
    ) {
        self.notificationCenter = notificationCenter
        self.userDefaults = userDefaults
    }
    
    public func isEnabled() -> Bool {
        userDefaults.bool(forKey: Constant.enabledKey)
    }
    
    public func setEnabled(_ isEnabled: Bool) {
        userDefaults.set(isEnabled, forKey: Constant.enabledKey)
    }
    
    public func fetchConfig() -> (hour: Int, minute: Int, weekdays: Set<Int>)? {
        guard isEnabled(),
              let weekdaysArray = userDefaults.array(forKey: Constant.scheduledWeekdaysKey) as? [Int],
              !weekdaysArray.isEmpty,
              userDefaults.object(forKey: Constant.hourKey) != nil else {
            return nil
        }
        let hour = userDefaults.integer(forKey: Constant.hourKey)
        let minute = userDefaults.integer(forKey: Constant.minuteKey)
        return (hour: hour, minute: minute, weekdays: Set(weekdaysArray))
    }

    public func schedule(hour: Int, minute: Int, weekdays: Set<Int>) -> AnyPublisher<Void, Error> {
        cancel()

        let publishers = weekdays.map { scheduleSingle(weekday: $0, hour: hour, minute: minute) }
        userDefaults.set(Array(weekdays), forKey: Constant.scheduledWeekdaysKey)
        userDefaults.set(hour, forKey: Constant.hourKey)
        userDefaults.set(minute, forKey: Constant.minuteKey)

        return Publishers.MergeMany(publishers)
            .collect()
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func cancel() {
        let scheduled = userDefaults.array(forKey: Constant.scheduledWeekdaysKey) as? [Int] ?? []
        let identifiers = scheduled.map { "\(Constant.identifierPrefix)\($0)" }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        userDefaults.removeObject(forKey: Constant.scheduledWeekdaysKey)
        userDefaults.removeObject(forKey: Constant.hourKey)
        userDefaults.removeObject(forKey: Constant.minuteKey)
    }

    private func scheduleSingle(weekday: Int, hour: Int, minute: Int) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }

            let content = UNMutableNotificationContent()
            content.title = "일기 쓸 시간이에요"
            content.body = "오늘 하루는 어땠나요? 잊지 말고 일기를 남겨보세요."
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.weekday = weekday
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "\(Constant.identifierPrefix)\(weekday)",
                content: content,
                trigger: trigger
            )

            self.notificationCenter.add(request) { error in
                error == nil ? promise(.success(())) : promise(.failure(error!))
            }
        }
        .eraseToAnyPublisher()
    }
}
