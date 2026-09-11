//
//  NotificationSettingViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/25/25.
//

import Foundation
import Combine
import HilingualDomain

public final class NotificationSettingViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let marketingToggled: AnyPublisher<Void, Never>
        let feedToggled: AnyPublisher<Void, Never>
        let reminderToggled: AnyPublisher<Void, Never>
        let isSystemPermissionGranted: AnyPublisher<Bool, Never>
    }

    // MARK: - Output

    public struct Output {
        let isMarketingOn: AnyPublisher<Bool, Never>
        let isFeedOn: AnyPublisher<Bool, Never>
        let isReminderOn: AnyPublisher<Bool, Never>
        let reminderSubtitle: AnyPublisher<String, Never>
        let settingUpdateError: AnyPublisher<Error, Never>
        let loadError: AnyPublisher<Error, Never>
        let shouldShowBanner: AnyPublisher<Bool, Never>
    }

    // MARK: - Private Subjects

    private let marketingSubject = CurrentValueSubject<Bool, Never>(false)
    private let feedSubject = CurrentValueSubject<Bool, Never>(false)
    private let reminderSubject = CurrentValueSubject<Bool, Never>(false)
    private let reminderConfigSubject = CurrentValueSubject<(hour: Int, minute: Int, weekdays: Set<Int>)?, Never>(nil)
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let loadErrorSubject = PassthroughSubject<Error, Never>()

    // MARK: - Properties

    private let useCase: AlarmSettingUseCase
    private let diaryReminderUseCase: DiaryReminderUseCase

    // MARK: - Init

    public init(useCase: AlarmSettingUseCase, diaryReminderUseCase: DiaryReminderUseCase) {
        self.useCase = useCase
        self.diaryReminderUseCase = diaryReminderUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<AlarmSettingEntity, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return self.useCase.fetchAlarmSetting()
                    .catch { [weak self] error -> Empty<AlarmSettingEntity, Never> in
                        self?.loadErrorSubject.send(error)
                        return .init()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] entity in
                self?.marketingSubject.send(entity.isMarketingAlarmOn)
                self?.feedSubject.send(entity.isFeedAlarmOn)
            }
            .store(in: &cancellables)
        
        input.viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<(Bool, (hour: Int, minute: Int, weekdays: Set<Int>)?), Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return Publishers.Zip(
                    self.diaryReminderUseCase.fetchReminderStatus(),
                    self.diaryReminderUseCase.fetchReminderConfig()
                ).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOn, config in
                self?.reminderSubject.send(isOn)
                self?.reminderConfigSubject.send(config)
            }
            .store(in: &cancellables)
        
        input.marketingToggled
            .sink { [weak self] in
                guard let self = self else { return }
                let newValue = !self.marketingSubject.value
                self.toggleSetting(for: "MARKETING", isOn: newValue)
            }
            .store(in: &cancellables)

        input.feedToggled
            .sink { [weak self] in
                guard let self = self else { return }
                let newValue = !self.feedSubject.value
                self.toggleSetting(for: "FEED", isOn: newValue)
            }
            .store(in: &cancellables)
        
        input.reminderToggled
            .sink { [weak self] in
                self?.disableReminder()
            }
            .store(in: &cancellables)
        
        let shouldShowBanner = input.isSystemPermissionGranted
            .map { !$0 }
            .eraseToAnyPublisher()
        
        let reminderSubtitle = Publishers.CombineLatest(reminderSubject, reminderConfigSubject)
            .map { isOn, config -> String in
                guard isOn, let config else {
                    return "설정한 시간에 리마인드 알림을 보내드려요."
                }
                return Self.formatReminderSubtitle(
                    hour: config.hour,
                    minute: config.minute,
                    weekdays: config.weekdays
                )
            }
            .eraseToAnyPublisher()

        return Output(
            isMarketingOn: marketingSubject.eraseToAnyPublisher(),
            isFeedOn: feedSubject.eraseToAnyPublisher(),
            isReminderOn: reminderSubject.eraseToAnyPublisher(),
            reminderSubtitle: reminderSubtitle,
            settingUpdateError: errorSubject.eraseToAnyPublisher(),
            loadError: loadErrorSubject.eraseToAnyPublisher(),
            shouldShowBanner: shouldShowBanner
        )
    }

    // MARK: - Private

    private func toggleSetting(for type: String, isOn: Bool) {
        useCase.toggleNotificationSetting(notiType: type)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorSubject.send(error)
                }
            }, receiveValue: { [weak self] in
                if type == "MARKETING" {
                    self?.marketingSubject.send(isOn)
                } else if type == "FEED" {
                    self?.feedSubject.send(isOn)
                }
            })
            .store(in: &cancellables)
    }
    
    private func disableReminder() {
        diaryReminderUseCase.disableReminder()
        reminderSubject.send(false)
        reminderConfigSubject.send(nil)
    }
    
    private static func formatReminderSubtitle(hour: Int, minute: Int, weekdays: Set<Int>) -> String {
        let dayText: String
        if weekdays.count == 7 {
            dayText = "매일"
        } else {
            let names = [1: "일", 2: "월", 3: "화", 4: "수", 5: "목", 6: "금", 7: "토"]
            dayText = (1...7).compactMap { weekdays.contains($0) ? names[$0] : nil }.joined(separator: ", ")
        }
        let period = hour < 12 ? "오전" : "오후"
        let hour12 = hour % 12 == 0 ? 12 : hour % 12
        return "\(dayText) • \(period) \(hour12):\(String(format: "%02d", minute))"
    }
}
