//
//  DeviceRequestDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 3/21/26.
//

import Foundation

public struct DeviceRequestDTO: Encodable {
    public let timezone: String
    public let deviceUuid: String
    public let deviceName: String
    public let deviceType: String
    public let osType: String
    public let osVersion: String
    public let appVersion: String

    public init(
        timezone: String,
        deviceUuid: String,
        deviceName: String,
        deviceType: String,
        osType: String,
        osVersion: String,
        appVersion: String
    ) {
        self.timezone = timezone
        self.deviceUuid = deviceUuid
        self.deviceName = deviceName
        self.deviceType = deviceType
        self.osType = osType
        self.osVersion = osVersion
        self.appVersion = appVersion
    }
}
