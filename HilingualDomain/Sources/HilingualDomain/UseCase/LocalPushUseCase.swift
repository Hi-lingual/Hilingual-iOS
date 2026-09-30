//
//  LocalPushUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 12/21/25.
//

import Foundation

public protocol LocalPushUseCase {
    func cancelLegacyPushes()
}

public final class DefaultLocalPushUseCase: LocalPushUseCase {
    private let repository: LocalPushRepository

    public init(repository: LocalPushRepository) {
        self.repository = repository
    }
    
    public func cancelLegacyPushes() {
        let ids = (2...7).map { "daily_push_\($0)" } + ["weekly_push_sun"]
        repository.cancelNotifications(ids: ids)
    }
}
