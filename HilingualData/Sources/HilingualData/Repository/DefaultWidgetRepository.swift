//
//  DefaultWidgetRepository.swift
//  HilingualData
//
//  Created by youngseo on 8/23/26.
//

import Combine
import Foundation
import HilingualDomain
import HilingualNetwork

public final class DefaultWidgetRepository: WidgetRepository {
    private let topicService: WidgetTopicService
    private let streakService: WidgetStreakService

    public init(
        topicService: WidgetTopicService,
        streakService: WidgetStreakService
    ) {
        self.topicService = topicService
        self.streakService = streakService
    }

    public func fetchWidgetTopic(date: String) -> AnyPublisher<WidgetTopicEntity, Error> {
        return topicService.fetchWidgetTopic(date: date)
            .map { $0.data.toEntity() }
            .eraseToAnyPublisher()
    }

    public func fetchWidgetStreak(date: String) -> AnyPublisher<WidgetStreakEntity, Error> {
        return streakService.fetchWidgetStreak(date: date)
            .map { $0.data.toEntity() }
            .eraseToAnyPublisher()
    }
}
