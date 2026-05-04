//
//  MonthInfoEntity.swift
//  HilingualDomain
//
//  Created by 조영서 on 7/16/25.
//

import Foundation

public struct MonthInfoEntity {
    public let dates: [Date]
    
    //다른 모듈에서 사용하기 위한 초기화
    public init(dates: [Date]) {
        self.dates = dates
    }
}
