//
//  LocalPushUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 12/21/25.
//

import Foundation

public protocol LocalPushUseCase {
    func registerInitialPushes()
}

public final class DefaultLocalPushUseCase: LocalPushUseCase {
    private let repository: LocalPushRepository

    public init(repository: LocalPushRepository) {
        self.repository = repository
    }

    public func registerInitialPushes() {
        guard !repository.isScheduled() else { return }

        for weekday in 2...7 {
            repository.registerNotification(
                id: "daily_push_\(weekday)",
                title: "하루를 정리해 볼 시간 ✍️",
                body: "오늘 하루를 돌아보며 떠오르는 생각들을 자유롭게 적어보세요.",
                weekday: weekday,
                hour: 22,
                minute: 0
            )
        }

        repository.registerNotification(
            id: "weekly_push_sun",
            title: "한 주를 정리해보는 시간 ✍️",
            body: "특별한 주제가 없어도 괜찮아요. 그냥 생각나는 걸 써보세요.",
            weekday: 1,
            hour: 19,
            minute: 0
        )

        repository.saveScheduledStatus(true)
    }
}
