//
//  NetworkError.swift
//  Hilingual
//
//  Created by 성현주 on 7/3/25.
//

import Foundation

enum NetworkError: Error {
    case decoding
    case unauthorized
    case forbidden
    case notFound
    case serverError(ServerError)
    case networkFail
    case timeout
    case unknown
}

struct ServerError: Decodable, Error {
    let code: Int
    let message: String
}
