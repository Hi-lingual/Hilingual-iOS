//
//  LoginOnBoardingViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import Foundation
import Combine

public final class LoginOnBoardingViewModel: BaseViewModel {

    public struct Input {
        let startTapped: AnyPublisher<Void, Never>
    }

    public struct Output {
        let navigateToLogin: AnyPublisher<Void, Never>
    }

    private let loginSubject = PassthroughSubject<Void, Never>()

    public override init() {
        super.init()
    }

    public func transform(input: Input) -> Output {
        input.startTapped
            .sink { [weak self] in
                self?.loginSubject.send()
            }
            .store(in: &cancellables)

        return Output(navigateToLogin: loginSubject.eraseToAnyPublisher())
    }
}
