//
//  BaseAPIResponse.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation

public struct BaseAPIResponse<T: Decodable>: Decodable {
    public let code: Int
    public let data: T
    public let message: String
}
