//
//  WidgetUseCase.swift
//  HilingualDomain
//
//  Created by youngseo on 8/23/26.
//

import Combine
import Foundation

public protocol WidgetUseCase {
    func fetchWidgetTopic(date: String) -> AnyPublisher<WidgetTopicEntity, Error>
    func fetchWidgetStreak(date: String) -> AnyPublisher<WidgetStreakEntity, Error>
}

public final class DefaultWidgetUseCase: WidgetUseCase {
    private let repository: WidgetRepository

    public init(repository: WidgetRepository) {
        self.repository = repository
    }

    public func fetchWidgetTopic(date: String) -> AnyPublisher<WidgetTopicEntity, Error> {
        return repository.fetchWidgetTopic(date: date)
    }

    public func fetchWidgetStreak(date: String) -> AnyPublisher<WidgetStreakEntity, Error> {
        return repository.fetchWidgetStreak(date: date)
    }
}
