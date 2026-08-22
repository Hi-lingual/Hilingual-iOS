//
//  WidgetSyncService.swift
//  Hilingual
//
//  Created by youngseo on 8/23/26.
//

import Combine
import Foundation
import HilingualDomain
import WidgetKit

@MainActor
final class WidgetSyncService {
    static let shared = WidgetSyncService()

    private var useCase: WidgetUseCase?
    private var cancellables = Set<AnyCancellable>()

    private init() {}

    func configure(useCase: WidgetUseCase) {
        self.useCase = useCase
    }

    func syncTodayWidgets() {
        guard let useCase else { return }

        let today = Date()
        let dateString = today.widgetAPIDateText

        useCase.fetchWidgetTopic(date: dateString)
            .sink { completion in
                if case .failure = completion {
                    WidgetContentStore.saveTopicFailure(updatedAt: today)
                    WidgetCenter.shared.reloadTimelines(ofKind: "RecommendedTopicWidget")
                }
            } receiveValue: { entity in
                WidgetContentStore.saveTopic(entity, updatedAt: today)
                WidgetCenter.shared.reloadTimelines(ofKind: "RecommendedTopicWidget")
            }
            .store(in: &cancellables)

        useCase.fetchWidgetStreak(date: dateString)
            .sink { _ in
            } receiveValue: { entity in
                WidgetContentStore.saveStreak(entity, updatedAt: today)
                WidgetCenter.shared.reloadTimelines(ofKind: "StreakWidget")
            }
            .store(in: &cancellables)
    }
}

private extension Date {
    var widgetAPIDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
