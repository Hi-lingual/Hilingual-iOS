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
    }

    // MARK: - Output

    public struct Output {
        let isMarketingOn: AnyPublisher<Bool, Never>
        let isFeedOn: AnyPublisher<Bool, Never>
        let settingUpdateError: AnyPublisher<Error, Never>
    }

    // MARK: - Private Subjects

    private let marketingSubject = CurrentValueSubject<Bool, Never>(false)
    private let feedSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()

    // MARK: - Properties

    private let useCase: AlarmSettingUseCase

    // MARK: - Init

    public init(useCase: AlarmSettingUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {

        input.viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<AlarmSettingEntity, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return self.useCase.fetchAlarmSetting()
                    .catch { [weak self] error -> Empty<AlarmSettingEntity, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] entity in
                self?.marketingSubject.send(entity.isMarketingAlarmOn)
                self?.feedSubject.send(entity.isFeedAlarmOn)
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

        return Output(
            isMarketingOn: marketingSubject.eraseToAnyPublisher(),
            isFeedOn: feedSubject.eraseToAnyPublisher(),
            settingUpdateError: errorSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private

    private func toggleSetting(for type: String, isOn: Bool) {
        useCase.toggleNotificationSetting(notiType: type)
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
}
