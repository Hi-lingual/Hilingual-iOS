//
//  DefaultHomeRepository.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

import HilingualDomain
import HilingualNetwork
import Foundation

public final class DefaultHomeRepository: HomeRepository {

    private let service: HomeService

    public init(service: HomeService) {
        self.service = service
    }

    public func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error> {
        return service.fetchUserInfo()
            .tryMap { dto in
                guard let data = dto.data else {
                    throw NetworkError.decoding
                }

                return UserInfoEntity(
                    nickname: data.nickname,
                    profileImg: data.profileImg,
                    totalDiaries: data.totalDiaries,
                    streak: data.streak
                )
            }
            .eraseToAnyPublisher()
    }

    public func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoEntity, Error> {
        return service.fetchMonthInfo(year: year, month: month)
            .tryMap { dto in
                guard let data = dto.data else {
                    throw NetworkError.decoding
                }
                return data.toEntity()
            }
            .eraseToAnyPublisher()
    }

    public func fetchDiaryInfo(for date: String) -> AnyPublisher<DiaryInfoEntity?, Error> {
        return service.fetchDiaryInfo(date: date)
            .tryMap { dto in
                guard let data = dto.data else {
                    throw NetworkError.decoding
                }
                return DiaryInfoMapper.map(from: data)
            }
            .eraseToAnyPublisher()
    }

    public func fetchTopic(for date: String) -> AnyPublisher<TopicEntity?, Error> {
        return service.fetchTopic(date: date)
            .tryMap { dto in
                guard let data = dto.data else {
                    throw NetworkError.decoding
                }
                return TopicMapper.map(from: data)
            }
            .eraseToAnyPublisher()
    }
    
    public func publishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.publishDiary(diaryId: diaryId)
            .eraseToAnyPublisher()
    }
    
    public func unpublishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.unpublishDiary(diaryId: diaryId)
            .eraseToAnyPublisher()
    }
    
    public func deleteDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return service.deleteDiary(diaryId: diaryId)
            .eraseToAnyPublisher()
    }
}
