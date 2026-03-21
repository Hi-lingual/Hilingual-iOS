//
//  MonthInfoDTO+Mapper.swift
//  HilingualData
//
//  Created by 조영서 on 7/16/25.
//

import Foundation
import HilingualNetwork
import HilingualDomain

extension DateListDTO {
    public func toEntity() -> MonthInfoEntity {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")

        let parsedDates = dateList.compactMap { formatter.date(from: $0.date) }

        return MonthInfoEntity(dates: parsedDates)
    }
}
