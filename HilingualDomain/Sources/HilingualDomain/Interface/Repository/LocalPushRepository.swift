//
//  LocalPushRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 12/21/25.
//

import Foundation

public protocol LocalPushRepository {
    func isScheduled() -> Bool
    func saveScheduledStatus(_ scheduled: Bool)
    func registerNotification(id: String, title: String, body: String, weekday: Int, hour: Int, minute: Int)
}
