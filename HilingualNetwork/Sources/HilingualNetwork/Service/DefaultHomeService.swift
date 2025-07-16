//
//  HomeService.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya
import Combine

public protocol HomeService {
    func fetchUserInfo() -> AnyPublisher<UserInfoDTO, Error>
    func fetchMonthInfo() -> AnyPublisher<MonthInfoDTO, Error>
}

public final class DefaultHomeService: BaseService<HomeAPI>, HomeService {
    public func fetchUserInfo() -> AnyPublisher<UserInfoDTO, Error> {
        return request(.getUserInfo, as: UserInfoDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    public func fetchMonthInfo() -> AnyPublisher<MonthInfoDTO, Error> {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)

        return request(.getMonthInfo(year: year, month: month), as: MonthInfoDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
