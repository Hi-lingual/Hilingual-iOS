//
//  WidgetRepository.swift
//  HilingualDomain
//
//  Created by youngseo on 8/23/26.
//

import Combine
import Foundation

public protocol WidgetRepository {
    func fetchWidgetTopic(date: String) -> AnyPublisher<WidgetTopicEntity, Error>
    func fetchWidgetStreak(date: String) -> AnyPublisher<WidgetStreakEntity, Error>
}
