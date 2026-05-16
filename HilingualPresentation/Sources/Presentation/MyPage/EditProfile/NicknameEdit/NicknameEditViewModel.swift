//
//  NicknameEditViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/16/26.
//

import Combine
import Foundation
import HilingualDomain

public final class NicknameEditViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let nicknameChanged: AnyPublisher<String, Never>
        let changeTapped: AnyPublisher<Void, Never>
    }

    public struct Output {
        let nicknameState: AnyPublisher<nickNameTextField.State, Never>
        let changeButtonEnabled: AnyPublisher<Bool, Never>
        let updateSuccess: AnyPublisher<String, Never>
        let updateError: AnyPublisher<Error, Never>
    }

    // MARK: - Properties

    private let currentNickname: String
    private let onBoardingUseCase: OnBoardingUseCase
    private let userProfileUseCase: FetchUserProfileUseCase
    private let nicknameStateSubject = PassthroughSubject<nickNameTextField.State, Never>()
    private let changeButtonEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let updateSuccessSubject = PassthroughSubject<String, Never>()
    private let updateErrorSubject = PassthroughSubject<Error, Never>()
    private var latestNickname: String = ""
    private var duplicateCheckWorkItem: DispatchWorkItem?
    private var duplicateCheckCancellable: AnyCancellable?

    // MARK: - Init

    public init(
        currentNickname: String,
        onBoardingUseCase: OnBoardingUseCase,
        userProfileUseCase: FetchUserProfileUseCase
    ) {
        self.currentNickname = currentNickname
        self.onBoardingUseCase = onBoardingUseCase
        self.userProfileUseCase = userProfileUseCase
        self.latestNickname = currentNickname
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.nicknameChanged
            .sink { [weak self] nickname in
                self?.nicknameDidChange(nickname)
            }
            .store(in: &cancellables)

        input.changeTapped
            .sink { [weak self] in
                self?.updateNickname()
            }
            .store(in: &cancellables)

        return Output(
            nicknameState: nicknameStateSubject.eraseToAnyPublisher(),
            changeButtonEnabled: changeButtonEnabledSubject.eraseToAnyPublisher(),
            updateSuccess: updateSuccessSubject.eraseToAnyPublisher(),
            updateError: updateErrorSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func nicknameDidChange(_ text: String) {
        let nickname = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard nickname != latestNickname else { return }

        latestNickname = nickname
        changeButtonEnabledSubject.send(false)
        duplicateCheckWorkItem?.cancel()
        duplicateCheckCancellable?.cancel()

        if nickname == currentNickname {
            nicknameStateSubject.send(.normal)
            return
        }

        switch onBoardingUseCase.validate(nickname) {
        case .empty:
            nicknameStateSubject.send(.normal)
        case .tooShort:
            nicknameStateSubject.send(.error("최소 2글자 이상 입력해주세요.", shouldShake: false))
        case .containsInvalidCharacters:
            nicknameStateSubject.send(.error("특수문자, 이모지는 사용이 불가능해요."))
        case .valid:
            nicknameStateSubject.send(.wait)
            scheduleDuplicateCheck(for: nickname)
        }
    }

    private func scheduleDuplicateCheck(for nickname: String) {
        let workItem = DispatchWorkItem { [weak self] in
            self?.checkDuplicate(nickname)
        }

        duplicateCheckWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }

    private func checkDuplicate(_ nickname: String) {
        duplicateCheckCancellable = onBoardingUseCase.checkDuplicate(nickname)
            .sink { [weak self] isAvailable, message in
                guard let self, nickname == latestNickname else { return }

                if isAvailable {
                    nicknameStateSubject.send(.success(message ?? "사용 가능한 닉네임이에요."))
                    changeButtonEnabledSubject.send(true)
                } else {
                    nicknameStateSubject.send(.error(message ?? "이미 사용중인 닉네임이에요."))
                    changeButtonEnabledSubject.send(false)
                }
            }
    }

    private func updateNickname() {
        guard changeButtonEnabledSubject.value else { return }
        requestNicknameUpdate(latestNickname)
    }

    private func requestNicknameUpdate(_ nickname: String) {
        userProfileUseCase.updateNickname(nickname: nickname)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.updateErrorSubject.send(error)
                    }
                },
                receiveValue: { [weak self] in
                    self?.updateSuccessSubject.send(nickname)
                }
            )
            .store(in: &cancellables)
    }
}
