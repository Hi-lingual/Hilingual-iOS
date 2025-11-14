//
//  HomeViewModel.swift
//  Hilingual
//
//  Created by 조영서 on 7/16/25.
//

import Combine
import Foundation
import HilingualDomain

enum MenuAction {
    case publish, unpublish, delete
}

public final class HomeViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
        let monthChange = PassthroughSubject<(Int, Int), Never>()
        let checkDraft = PassthroughSubject<Date, Never>()
    }

    // MARK: - Output

    public struct Output {
        let userInfo: AnyPublisher<UserInfoEntity, Error>
        let filledDates: AnyPublisher<[Date], Never>
    }

    // MARK: - Properties

    private let useCase: HomeUseCase
    private let fetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase

    public let hasDraft = PassthroughSubject<Bool, Never>()

    // MARK: - Init

    public init(
        useCase: HomeUseCase,
        fetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase
    ) {
        self.useCase = useCase
        self.fetchTemporaryDiaryUseCase = fetchTemporaryDiaryUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        let userInfoPublisher = useCase.fetchUserInfo()
            .eraseToAnyPublisher()

        let filledDatesPublisher = input.monthChange
            .flatMap { year, month in
                self.useCase.fetchMonthInfo(year: year, month: month)
                    .map { $0.dates }
                    .catch { _ in Just([]) }
            }
            .eraseToAnyPublisher()
        
        input.checkDraft
            .flatMap { date in
                self.fetchTemporaryDiaryUseCase.execute(date)
                    .catch { _ in Just(nil) }
            }
            .sink { [weak self] draft in
                self?.hasDraft.send(draft != nil)
            }
            .store(in: &cancellables)

        return Output(
            userInfo: userInfoPublisher,
            filledDates: filledDatesPublisher
        )
    }


    // MARK: - Additional Fetch Methods

    public func fetchDiary(for date: Date) -> AnyPublisher<DiaryInfoEntity?, Error> {
        let dateString = date.toFormattedString("yyyy-MM-dd")
        return useCase.fetchDiaryInfo(for: dateString)
    }

    public func fetchTopic(for date: Date) -> AnyPublisher<TopicEntity?, Error> {
        let dateString = date.toFormattedString("yyyy-MM-dd")
        return useCase.fetchTopic(for: dateString)
    }
    
    public func fetchMonthInfo(year: Int, month: Int) -> AnyPublisher<MonthInfoEntity, Error> {
        return useCase.fetchMonthInfo(year: year, month: month)
    }
    
    public func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error> {
        return useCase.fetchUserInfo()
    }
    
    public func publishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return useCase.publishDiary(diaryId: diaryId)
    }
    
    public func unpublishDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return useCase.unpublishDiary(diaryId: diaryId)
    }
    
    public func deleteDiary(diaryId: Int) -> AnyPublisher<Void, Error> {
        return useCase.deleteDiary(diaryId: diaryId)
    }
}
