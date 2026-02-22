//
//  HomeUseCase.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

public protocol HomeUseCase {
    func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error>
    func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoEntity, Error>
    func fetchDiaryInfo(for date: String) -> AnyPublisher<DiaryInfoEntity?, Error>
    func fetchTopic(for date: String) -> AnyPublisher<TopicEntity?, Error>
    func publishDiary(diaryId: Int) -> AnyPublisher<Void, Error>
    func unpublishDiary(diaryId: Int) -> AnyPublisher<Void, Error>
    func deleteDiary(diaryId: Int) -> AnyPublisher<Void, Error>
}

public final class DefaultHomeUseCase: HomeUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error> {
        return repository.fetchUserInfo()
    }

    public func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoEntity, Error> {
        return repository.fetchMonthInfo(year: year, month: month)
    }

    public func fetchDiaryInfo(for date: String) -> AnyPublisher<DiaryInfoEntity?, Error> {
        return repository.fetchDiaryInfo(for: date)
    }

    public func fetchTopic(for date: String) -> AnyPublisher<TopicEntity?, Error> {
        return repository.fetchTopic(for: date)
    }
    
    public func publishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return repository.publishDiary(diaryId: diaryId)
    }
    
    public func unpublishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return repository.unpublishDiary(diaryId: diaryId)
    }
    
    public func deleteDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return repository.deleteDiary(diaryId: diaryId)
    }
}
