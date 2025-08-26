//
//  MockHomeService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 8/27/25.
//

import Foundation
import Combine

public final class MockHomeService: HomeService {
    
    public init() {}
    
    // MARK: - User Info
    public func fetchUserInfo() -> AnyPublisher<UserInfoDTO, Error> {
        let mockUserData = UserInfoDataDTO(
            nickname: "태버",
            profileImg: "https://i.namu.wiki/i/VhnAGWIdCid5Set_fzuLY-mTNpnqu_r1vwaJmU8MmDMmjFHeCh_aJybjkJZi3orhP-iWELvdatsYG1iWkHJOmS3MnCVoxrh0Y6CqV-N1lzn25Y1OrtHVLnoW59A88301FI0M-1V3l7PPH7HST0AVQg.webp",
            totalDiaries: 916,
            streak: 7,
            newAlarm: true
        )
        
        let mockDTO = UserInfoDTO(
            code: 200,
            data: mockUserData,
            message: "회원의 기본정보 조회에 성공했습니다"
        )
        
        return Just(mockDTO)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Month Info
    public func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoDTO, Error> {
        let calendar = Calendar.current
        let today = Date()
        
        let predefinedDays: [Int]
        switch month {
        case 6: predefinedDays = [1, 3, 5, 12, 26]
        case 7: predefinedDays = [2, 8, 15]
        case 8: predefinedDays = [1, 5, 20]
        default: predefinedDays = [1, 10, 20]
        }
        
        let validDays = predefinedDays.filter { day in
            guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else { return false }
            return date <= today
        }
        
        let mockDates = validDays.map { day in
            DateDTO(date: String(format: "%04d-%02d-%02d", year, month, day))
        }
        
        let mockData = DateListDTO(dateList: mockDates)
        let mockDTO = MonthInfoDTO(
            code: 20000,
            data: mockData,
            message: "월별 조회에 성공했습니다"
        )
        
        return Just(mockDTO)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Diary Info
    public func fetchDiaryInfo(date: String) -> AnyPublisher<DiaryInfoDTO, Error> {
        let mockDiary = DiaryInfoDTO.DiaryDataDTO(
            diaryId: 1,
            imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7zO8uMM-dPCiPPzr0p_K0Z16GAUy26wPhNQ&s",
            originalText: "Today was such a meaningful day. I went to the park...",
            isPublished: false
        )
        let mock = DiaryInfoDTO(data: mockDiary)
        return Just(mock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Topic Info
    public func fetchTopic(date: String) -> AnyPublisher<TopicDTO, Error> {
        let mockTopicData = TopicDTO.TopicDataDTO(
            topicKor: "오늘의 주제",
            topicEn: "Today's Topic",
            remainingTime: 120
        )
        let mockDTO = TopicDTO(data: mockTopicData)
        return Just(mockDTO)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
