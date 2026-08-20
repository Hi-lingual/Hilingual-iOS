//
//  HomeAdWatchRequestDTO.swift
//  HilingualNetwork
//
//  Created by youngseo on 6/18/26.
//

import Foundation

public struct HomeAdWatchRequestDTO: Encodable {
    public let targetDate: String

    public init(targetDate: String) {
        self.targetDate = targetDate
    }
}
