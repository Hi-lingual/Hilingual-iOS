//
//  HomeRepository.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine
import Foundation

public protocol HomeRepository {
    func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error>
    func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoEntity, Error>
    func fetchDiaryInfo(for date: String) -> AnyPublisher<DiaryInfoEntity?, Error>
    func fetchTopic(for date: String) -> AnyPublisher<TopicEntity?, Error>
}
