//
//  HilingualError.swift
//  HilingualCore
//
//  Created by 성현주 on 6/27/26.
//

import Foundation

public enum HilingualError: Error, Equatable {
    case dataNotFound
    case network
    case server
    case unauthorized

    public static func from(_ error: Error) -> HilingualError {
        (error as? HilingualError) ?? .server
    }
}
