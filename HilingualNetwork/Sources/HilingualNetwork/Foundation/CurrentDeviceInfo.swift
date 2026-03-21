//
//  CurrentDeviceInfo.swift
//  HilingualNetwork
//
//  Created by 성현주 on 3/21/26.
//

import Foundation
import UIKit

struct CurrentDeviceInfo {
    let timezone: String
    let deviceUUID: String
    let deviceName: String
    let deviceType: String
    let osType: String
    let osVersion: String
    let appVersion: String

    static func make() -> CurrentDeviceInfo {
        let deviceUUID: String = {
            if !KeychainHandler.deviceUUID.isEmpty {
                return KeychainHandler.deviceUUID
            }

            let newUUID = UUID().uuidString
            KeychainHandler.deviceUUID = newUUID
            return newUUID
        }()

        return CurrentDeviceInfo(
            timezone: TimeZone.current.identifier,
            deviceUUID: deviceUUID,
            deviceName: UIDevice.current.name,
            deviceType: {
#if targetEnvironment(macCatalyst)
                return "DESKTOP"
#elseif os(iOS)
                return UIDevice.current.userInterfaceIdiom == .pad ? "TABLET" : "PHONE"
#else
                return "UNKNOWN"
#endif
            }(),
            osType: UIDevice.current.systemName,
            osVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        )
    }
}
