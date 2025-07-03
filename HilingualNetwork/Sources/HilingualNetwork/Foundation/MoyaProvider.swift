//
//  MoyaProvider.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Moya

public struct NetworkProvider {
    public static func make<T: TargetType>() -> MoyaProvider<T> {
        let logger = MoyaLoggerPlugin()
        return MoyaProvider<T>(
            plugins: [logger]
        )
    }
}

