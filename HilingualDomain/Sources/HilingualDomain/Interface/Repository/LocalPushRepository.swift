//
//  LocalPushRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 12/21/25.
//

import Foundation

public protocol LocalPushRepository {
    func cancelNotifications(ids: [String])
    func clearLegacyScheduledFlag()
}
