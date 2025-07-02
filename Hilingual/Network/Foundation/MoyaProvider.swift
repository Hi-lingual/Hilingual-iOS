//
//  MoyaProvider.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Moya

struct NetworkProvider {
    static func make<T: TargetType>() -> MoyaProvider<T> {
        return MoyaProvider<T>(
            plugins: [
                MoyaLoggerPlugin()
            ]
        )
    }
}
