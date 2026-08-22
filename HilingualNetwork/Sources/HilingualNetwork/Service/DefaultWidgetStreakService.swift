//
//  DefaultWidgetStreakService.swift
//  HilingualNetwork
//
//  Created by youngseo on 8/23/26.
//

import Foundation
import Combine

public protocol WidgetStreakService {
    func fetchWidgetStreak(date: String) -> AnyPublisher<BaseAPIResponse<WidgetStreakResponseDTO>, Error>
}

public final class DefaultWidgetStreakService: BaseService<WidgetStreakAPI>, WidgetStreakService {
    public func fetchWidgetStreak(date: String) -> AnyPublisher<BaseAPIResponse<WidgetStreakResponseDTO>, Error> {
        return request(.getStreak(date: date), as: BaseAPIResponse<WidgetStreakResponseDTO>.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
