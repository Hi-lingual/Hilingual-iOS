//
//  AlarmSettingDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/26/25.
//

import Foundation

public struct NotificationSettingsResponseDTO: Decodable {
    public let marketing: Bool
    public let feed: Bool
}
