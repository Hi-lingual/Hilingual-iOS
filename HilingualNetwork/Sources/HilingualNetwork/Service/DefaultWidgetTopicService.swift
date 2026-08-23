//
//  DefaultWidgetTopicService.swift
//  HilingualNetwork
//
//  Created by youngseo on 8/23/26.
//

import Foundation
import Combine

public protocol WidgetTopicService {
    func fetchWidgetTopic(date: String) -> AnyPublisher<BaseAPIResponse<WidgetTopicResponseDTO>, Error>
}

public final class DefaultWidgetTopicService: BaseService<WidgetTopicAPI>, WidgetTopicService {
    public func fetchWidgetTopic(date: String) -> AnyPublisher<BaseAPIResponse<WidgetTopicResponseDTO>, Error> {
        return request(.getTopic(date: date), as: BaseAPIResponse<WidgetTopicResponseDTO>.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
