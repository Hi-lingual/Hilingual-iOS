//
//  MoyaProvider.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Moya

import Moya
import Alamofire

public struct NetworkProvider {
    public static func make<T: TargetType>() -> MoyaProvider<T> {
        let logger = MoyaLoggerPlugin()

        let session = Session(interceptor: AuthInterceptor()) 
        return MoyaProvider<T>(session: session, plugins: [logger])
    }
}

