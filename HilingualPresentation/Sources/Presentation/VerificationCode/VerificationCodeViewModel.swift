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
        let showLockout: AnyPublisher<Void, Never>
    }

    // MARK: - Private

    private let verifyCodeUseCase: VerificationCodeUseCase
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    private let submitEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let successSubject = PassthroughSubject<Void, Never>()
    private let lockoutSubject = PassthroughSubject<Void, Never>()

    private var failCount: Int = 0
    private let maxAttempts: Int = 5

    // MARK: - Init

    public init(verifyCodeUseCase: VerificationCodeUseCase) {
        self.verifyCodeUseCase = verifyCodeUseCase
    }

    // MARK: - Transform

    func transform() -> Output {
        Output(
            errorMessage: errorSubject.eraseToAnyPublisher(),
            isSubmitEnabled: submitEnabledSubject.eraseToAnyPublisher(),
            didVerifySuccess: successSubject.eraseToAnyPublisher(),
            showLockout: lockoutSubject.eraseToAnyPublisher()
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
                guard let self else { return }
                if case let .failure(error) = completion {
                    self.failCount += 1
                    let base = Self.parseError(error)
                    let msg = "\(base) [실패 횟수 \(self.failCount)/\(self.maxAttempts)]"
                    self.errorSubject.send(msg)

                    if self.failCount >= self.maxAttempts {
                        self.lockoutSubject.send(())
                    }
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                self.errorSubject.send(nil)
                self.failCount = 0             
                self.successSubject.send(())
            }
            .store(in: &cancellables)
    }

    private static func isValidCode(_ code: String) -> Bool {
        code.count == 6 && code.allSatisfy(\.isNumber)
    }

    private static func parseError(_ error: Error) -> String {
        "유효하지 않은 인증코드입니다."
    }
}
