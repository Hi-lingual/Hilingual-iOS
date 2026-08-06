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

        case .serverError:
            return .server

        case .timeout, .decoding, .unknown, .forbidden:
            return .server
        }
    }
}
