//
//  ReminderTimeSettingViewModel.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 9/6/26.
//

import Foundation
import Combine
import HilingualDomain

public final class ReminderTimeSettingViewModel: BaseViewModel {

    public struct Input {
        let saveTapped: AnyPublisher<(hour: Int, minute: Int, weekdays: Set<Int>), Never>
    }

    public struct Output {
        let saveCompleted: AnyPublisher<Void, Never>
        let saveError: AnyPublisher<Error, Never>
    }

    private let saveCompletedSubject = PassthroughSubject<Void, Never>()
    private let saveErrorSubject = PassthroughSubject<Error, Never>()

    private let diaryReminderUseCase: DiaryReminderUseCase

    public init(diaryReminderUseCase: DiaryReminderUseCase) {
        self.diaryReminderUseCase = diaryReminderUseCase
    }

    public func transform(input: Input) -> Output {
        input.saveTapped
            .flatMap { [weak self] hour, minute, weekdays -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.diaryReminderUseCase.saveReminder(hour: hour, minute: minute, weekdays: weekdays)
                    .catch { [weak self] error -> Empty<Void, Never> in
                        self?.saveErrorSubject.send(error)
                        return .init()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] in self?.saveCompletedSubject.send(()) }
            .store(in: &cancellables)

        return Output(
            saveCompleted: saveCompletedSubject.eraseToAnyPublisher(),
            saveError: saveErrorSubject.eraseToAnyPublisher()
        )
    }
}
