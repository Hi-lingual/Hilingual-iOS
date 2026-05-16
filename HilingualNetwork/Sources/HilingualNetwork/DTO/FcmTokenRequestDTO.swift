//
//  FcmTokenRequestDTO.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 5/11/26.
//

import Foundation

public struct FcmTokenRequestDTO: Encodable {
    public let uuid: String
    public let fcmToken: String

    public init(uuid: String, fcmToken: String) {
        self.uuid = uuid
        self.fcmToken = fcmToken
    }
}
