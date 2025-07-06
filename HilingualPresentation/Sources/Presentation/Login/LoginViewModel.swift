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
    }

    public struct Output {
        let navigateToHome: AnyPublisher<Void, Never>
    }

    private let navigateToHomeSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init

    public override init() {
        super.init()
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.loginButtonTapped
            .sink { [weak self] in
                self?.navigateToHomeSubject.send(())
            }
            .store(in: &cancellables)

        return Output(navigateToHome: navigateToHomeSubject.eraseToAnyPublisher())
    }
}
