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
    func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoDTO, Error>
    func fetchDiaryInfo(date: String) -> AnyPublisher<DiaryInfoDTO, Error>
    func fetchTopic(date: String) -> AnyPublisher<TopicDTO, Error>
}

public final class DefaultHomeService: BaseService<HomeAPI>, HomeService {
    
    public func fetchUserInfo() -> AnyPublisher<UserInfoDTO, Error> {
        return request(.getUserInfo, as: UserInfoDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoDTO, Error> {
        return request(.getMonthInfo(year: year, month: month), as: MonthInfoDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func fetchDiaryInfo(date: String) -> AnyPublisher<DiaryInfoDTO, Error> {
        return request(.getDiaryInfo(date: date), as: DiaryInfoDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func fetchTopic(date: String) -> AnyPublisher<TopicDTO, Error> {
        return request(.getTopic(date: date), as: TopicDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
