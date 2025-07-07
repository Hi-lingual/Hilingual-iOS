//
//  LoginViewModel.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Combine

public final class LoginViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let loginButtonTapped: AnyPublisher<Void, Never>
        let nicknameChanged: AnyPublisher<String, Never>
    }

    public struct Output {
        let navigateToHome: AnyPublisher<Void, Never>
        let nicknameState: AnyPublisher<TextField.State, Never>
    }

    // MARK: - Subjects

    private let navigateToHomeSubject = PassthroughSubject<Void, Never>()

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.loginButtonTapped
            .sink { [weak self] in
                self?.navigateToHomeSubject.send(())
            }
            .store(in: &cancellables)

        //TODO: - 도메인 모듈에 위치
        let nicknameState = input.nicknameChanged
            .removeDuplicates()
            .map { nickname -> TextField.State in
                if nickname.isEmpty {
                    return .normal
                } else if nickname.count < 2 {
                    return .error("2자 이상 입력해주세요")
                } else if nickname == "sereal" {
                    return .error("사용할 수 없는 닉네임입니다")
                } else {
                    return .success("사용 가능한 닉네임이에요!")
                }
            }
            .eraseToAnyPublisher()

        return Output(
            navigateToHome: navigateToHomeSubject.eraseToAnyPublisher(),
            nicknameState: nicknameState
        )
    }
}
