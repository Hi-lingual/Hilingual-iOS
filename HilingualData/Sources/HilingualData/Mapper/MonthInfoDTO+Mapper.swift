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

        let writtenDates = dateList.compactMap { dto -> Date? in
            guard dto.status != "UNLOCKED" else { return nil }
            return formatter.date(from: dto.date)
        }
        let recoveredDates = dateList.compactMap { dto -> Date? in
            guard dto.status == "UNLOCKED" else { return nil }
            return formatter.date(from: dto.date)
        }

        return MonthInfoEntity(
            writtenDates: writtenDates,
            recoveredDates: recoveredDates
        )
    }
}
