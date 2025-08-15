//
//  VerificationCodeViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//

import Foundation
import Combine
import HilingualDomain

public final class VerificationCodeViewModel: BaseViewModel {

    // MARK: - Input / Output

    struct Output {
        let errorMessage: AnyPublisher<String?, Never>
        let isSubmitEnabled: AnyPublisher<Bool, Never>
        let didVerifySuccess: AnyPublisher<Void, Never>
    }

    // MARK: - Private

    private let verifyCodeUseCase: VerificationCodeUseCase
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    private let submitEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let successSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init

    public init(verifyCodeUseCase: VerificationCodeUseCase) {
        self.verifyCodeUseCase = verifyCodeUseCase
    }

    // MARK: - Transform

    func transform() -> Output {
        Output(
            errorMessage: errorSubject.eraseToAnyPublisher(),
            isSubmitEnabled: submitEnabledSubject.eraseToAnyPublisher(),
            didVerifySuccess: successSubject.eraseToAnyPublisher()
        )
    }

    func updateCode(_ code: String) {
        submitEnabledSubject.send(Self.isValidCode(code))
        errorSubject.send(nil)
    }

    func submit(code: String) {
        guard Self.isValidCode(code) else {
            errorSubject.send("인증코드는 숫자 6자리여야 합니다.")
            return
        }
        verifyCodeUseCase.execute(code: code)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send(Self.parseError(error))
                }
            } receiveValue: { [weak self] _ in
                self?.errorSubject.send(nil)
                self?.successSubject.send(())
            }
            .store(in: &cancellables)
    }

    private static func isValidCode(_ code: String) -> Bool {
        code.count == 6 && code.allSatisfy(\.isNumber)
    }

    private static func parseError(_ error: Error) -> String {
        "인증에 실패했습니다. 다시 시도해주세요."
    }
}
