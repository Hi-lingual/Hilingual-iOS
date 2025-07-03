//
//  HomeEntity.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

//도메인서 사용하는 엔티티
public struct HomeEntity {
    public let exchangeRate: String

    public init(exchangeRate: String) {
        self.exchangeRate = exchangeRate
    }
}
