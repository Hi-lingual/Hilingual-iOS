//
//  MoyaProvider.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Moya
import Alamofire

public struct NetworkProvider {
    public static func make<T: TargetType>() -> MoyaProvider<T> {
        let logger = MoyaLoggerPlugin()

        // refreshToken 요청은 interceptor 미적용
        if T.self == AuthAPI.self {
            return MoyaProvider<T>(plugins: [logger])
        }

        let session = Session(interceptor: AuthInterceptor.shared)
        return MoyaProvider<T>(session: session, plugins: [logger])
    }
}



