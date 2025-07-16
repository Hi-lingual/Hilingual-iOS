//
//  HomeViewModel.swift
//  Hilingual
//
//  Created by 조영서 on 7/16/25.
//

import Combine
import HilingualDomain

public final class HomeViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
        // 필요한 Input이 있다면 여기에 나중에 추가
    }

    // MARK: - Output

    public struct Output {
        let userInfo: AnyPublisher<UserInfoEntity, Error>
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

        return Output(userInfo: userInfoPublisher)
    }
}

