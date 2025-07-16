//
//  HomeViewModel.swift
//  Hilingual
//
//  Created by 조영서 on 7/16/25.
//

import Combine
import Foundation
import HilingualDomain

public final class HomeViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
        let monthChange = PassthroughSubject<(Int, Int), Never>()
    }

    // MARK: - Output

    public struct Output {
        let userInfo: AnyPublisher<UserInfoEntity, Error>
        let filledDates: AnyPublisher<[Date], Never>
    }

    // MARK: - Properties

    private let useCase: HomeUseCase

    // MARK: - Init

    public init(useCase: HomeUseCase) {
        self.useCase = useCase
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
}
