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

struct HomeUserInfoViewData {
    let nickname: String
    let profileImageURL: String?
    let totalDiaries: Int
    let streak: Int
    let recoveryTickets: Int
    let newAlarm: Bool
    
    init(entity: UserInfoEntity) {
        self.nickname = entity.nickname
        self.profileImageURL = entity.profileImg
        self.totalDiaries = entity.totalDiaries
        self.streak = entity.streak
        self.recoveryTickets = entity.recoveryTickets
        self.newAlarm = entity.newAlarm
    }
}

public final class HomeViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
        let monthChange = PassthroughSubject<(Int, Int), Never>()
        let checkDraft = PassthroughSubject<Date, Never>()
    }

    // MARK: - Output

    public struct Output {
        let userInfo: AnyPublisher<HomeUserInfoViewData, Error>
        let filledDates: AnyPublisher<[Date], Never>
    }

    // MARK: - Properties

    private let useCase: HomeUseCase
    private let fetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase
    private let localPushUseCase: LocalPushUseCase
    private let homeAdWatchUseCase: HomeAdWatchUseCase

    public let hasDraft = PassthroughSubject<Bool, Never>()

    // MARK: - Init

    public init(
        useCase: HomeUseCase,
        fetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase,
        localPushUseCase: LocalPushUseCase,
        homeAdWatchUseCase: HomeAdWatchUseCase
    ) {
        self.useCase = useCase
        self.fetchTemporaryDiaryUseCase = fetchTemporaryDiaryUseCase
        self.localPushUseCase = localPushUseCase
        self.homeAdWatchUseCase = homeAdWatchUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        let userInfoPublisher = fetchUserInfo()

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

    // MARK: - Local Push Methods
    
    public func registerInitialLocalPushes() {
        localPushUseCase.registerInitialPushes()
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
    
    func fetchUserInfo() -> AnyPublisher<HomeUserInfoViewData, Error> {
        return useCase.fetchUserInfo()
            .map { HomeUserInfoViewData(entity: $0) }
            .eraseToAnyPublisher()
    }

    public func postHomeAdWatch(for date: Date) -> AnyPublisher<Void, Error> {
        let targetDate = date.toFormattedString("yyyy-MM-dd")
        return homeAdWatchUseCase.execute(targetDate: targetDate)
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
