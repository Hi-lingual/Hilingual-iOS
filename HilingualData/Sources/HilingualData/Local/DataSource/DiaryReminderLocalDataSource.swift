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
        static let scheduledDateKeysKey = "diaryReminderScheduledDateKeys"
        static let rollingWindowDays = 14
    }

    private let notificationCenter: UNUserNotificationCenter
    private let userDefaults: UserDefaults
    private let calendar = Calendar.current

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
        cancelAll()

        userDefaults.set(Array(weekdays), forKey: Constant.scheduledWeekdaysKey)
        userDefaults.set(hour, forKey: Constant.hourKey)
        userDefaults.set(minute, forKey: Constant.minuteKey)

        return scheduleUpcomingOccurrences(hour: hour, minute: minute, weekdays: weekdays)
    }
    
    public func refreshUpcomingOccurrences() -> AnyPublisher<Void, Error> {
        guard let config = fetchConfig() else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return scheduleUpcomingOccurrences(hour: config.hour, minute: config.minute, weekdays: config.weekdays)
    }

    public func cancelReminder(for date: Date) {
        let key = dateKey(date)
        var scheduledKeys = Set(userDefaults.stringArray(forKey: Constant.scheduledDateKeysKey) ?? [])
        guard scheduledKeys.contains(key) else { return }

        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(Constant.identifierPrefix)\(key)"])
        scheduledKeys.remove(key)
        userDefaults.set(Array(scheduledKeys), forKey: Constant.scheduledDateKeysKey)
    }

    public func cancel() {
        cancelAll()
        userDefaults.removeObject(forKey: Constant.scheduledWeekdaysKey)
        userDefaults.removeObject(forKey: Constant.hourKey)
        userDefaults.removeObject(forKey: Constant.minuteKey)
    }
    
    // MARK: - Private
    
    private func cancelAll() {
        let scheduledKeys = userDefaults.stringArray(forKey: Constant.scheduledDateKeysKey) ?? []
        let identifiers = scheduledKeys.map { "\(Constant.identifierPrefix)\($0)" }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        userDefaults.removeObject(forKey: Constant.scheduledDateKeysKey)
    }
    
    private func scheduleUpcomingOccurrences(
        hour: Int,
        minute: Int,
        weekdays: Set<Int>
    ) -> AnyPublisher<Void, Error> {
        let today = calendar.startOfDay(for: Date())
        var alreadyScheduled = Set(userDefaults.stringArray(forKey: Constant.scheduledDateKeysKey) ?? [])
        var targetDates: [Date] = []
        
        for offset in 0..<Constant.rollingWindowDays {
            guard let date = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
            let weekday = calendar.component(.weekday, from: date)
            guard weekdays.contains(weekday) else { continue }
            
            if offset == 0 {
                var comps = calendar.dateComponents([.year, .month, .day], from: date)
                comps.hour = hour
                comps.minute = minute
                if let fireDate = calendar.date(from: comps), fireDate <= Date() { continue }
            }
            
            let key = dateKey(date)
            guard !alreadyScheduled.contains(key) else { continue }
            targetDates.append(date)
        }
        
        guard !targetDates.isEmpty else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        let publishers = targetDates.map { scheduleSingle(date: $0, hour: hour, minute: minute) }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self else { return }
                targetDates.forEach { alreadyScheduled.insert(self.dateKey($0)) }
                self.userDefaults.set(Array(alreadyScheduled), forKey: Constant.scheduledDateKeysKey)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    private func scheduleSingle(date: Date, hour: Int, minute: Int) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "일기 쓸 시간이에요 ⏰"
            content.body = "지금 떠오르는 생각을 영어로 기록해 보세요."
            content.sound = .default
            
            var comps = self.calendar.dateComponents([.year, .month, .day], from: date)
            comps.hour = hour
            comps.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(Constant.identifierPrefix)\(self.dateKey(date))",
                content: content,
                trigger: trigger
            )
            
            self.notificationCenter.add(request) { error in
                error == nil ? promise(.success(())) : promise(.failure(error!))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }
}
