//
//  PresignedURLAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/6/25.
//


import Foundation
import Moya

public enum PresignedURLAPI {
    case getPresignedURL(request: PresignedURLRequestDTO)
}

extension PresignedURLAPI: BaseTargetType {

    public var path: String {
        return "/presigned-urls"
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
           switch self {
           case .getPresignedURL(let request):
               return .requestJSONEncodable(request)
           }
       }

    public var sampleData: Data {
        return Data()
    }
}
