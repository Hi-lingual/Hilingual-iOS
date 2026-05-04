//
//  DeviceAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 3/21/26.
//

import Foundation
import Moya

public enum DeviceAPI {
    case updateDevice(requestDTO: DeviceRequestDTO)
}

extension DeviceAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .updateDevice:
            return "/users/device"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .updateDevice:
            return .put
        }
    }

    public var task: Task {
        switch self {
        case let .updateDevice(requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }

    public var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultHandler.accessToken)",
            "X-Timezone": TimeZone.autoupdatingCurrent.identifier
        ]
    }
}
