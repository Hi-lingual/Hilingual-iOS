//
//  OnBoardingViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import Foundation
import Combine
import HilingualDomain

public final class OnBoardingViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let nicknameChanged: AnyPublisher<String, Never>
    }

    public struct Output {
        let nicknameState: AnyPublisher<TextField.State, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
    }

    // MARK: - Private

    private let useCase: OnBoardingUseCase

    // MARK: - Init

    public init(useCase: OnBoardingUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        let nicknameStateSubject = input.nicknameChanged
            .map { [weak self] nickname -> TextField.State in
                guard let self = self else { return .normal }

                switch useCase.validate(nickname) {
                case .empty:
                    return .normal
                case .tooShort:
                    return .error("닉네임은 최소 2자 이상이어야 해요.")
                case .containsInvalidCharacters:
                    return .error("특수문자와 이모지는 사용할 수 없어요.")
                case .valid:
                    return .success("좋은데?ㅋㅋ")
                }
            }
            .share()

        let isNextButtonEnabled = nicknameStateSubject
            .map { state in
                if case .success = state {
                    return true
                } else {
                    return false
                }
            }
        
        return Output(
            nicknameState: nicknameStateSubject.eraseToAnyPublisher(),
            isNextButtonEnabled: isNextButtonEnabled.eraseToAnyPublisher()
        )
    }
}
