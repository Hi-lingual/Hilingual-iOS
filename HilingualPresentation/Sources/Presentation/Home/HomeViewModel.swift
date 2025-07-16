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
            .flatMap { _ in
                self.useCase.fetchMonthInfo()
                    .map { $0.dates }
                    .catch { _ in Just([]) }
            }
            .eraseToAnyPublisher()
        
        return Output(
            userInfo: userInfoPublisher,
            filledDates: filledDatesPublisher
        )
    }
}

