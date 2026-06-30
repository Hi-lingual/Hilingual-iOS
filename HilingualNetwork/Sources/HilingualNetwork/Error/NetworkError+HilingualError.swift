//
//  NetworkError+HilingualError.swift
//  HilingualNetwork
//
//  Created by 성현주 on 6/27/26.
//

import Foundation
import HilingualCore

extension NetworkError {

    func toHilingualError() -> HilingualError {
        switch self {
        case .notFound:
            return .dataNotFound

        case .unauthorized, .refreshFailed:
            return .unauthorized

        case .networkFail:
            return .network

        case .serverError(let serverError):
            return DataNotFoundPolicy.contains(code: serverError.code) ? .dataNotFound : .server

        case .timeout, .decoding, .unknown, .forbidden:
            return .server
        }
    }
}

enum DataNotFoundPolicy {
    private static let codes: Set<Int> = [
        40403,
        40404,
        40409,
        40410,
        40411,
        40412
    ]

    static func contains(code: Int) -> Bool {
        codes.contains(code)
    }
}
