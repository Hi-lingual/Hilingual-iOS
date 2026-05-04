//
//  KeychainHandler.swift
//  HilingualNetwork
//
//  Created by 성현주 on 3/21/26.
//

import Foundation

public struct KeychainHandler {
    @Keychain(key: "deviceUuid", defaultValue: "")
    public static var deviceUUID: String
}
