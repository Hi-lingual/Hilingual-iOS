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
        let startTapped: AnyPublisher<Bool, Never>
    }

    public struct Output {
        let nicknameState: AnyPublisher<TextField.State, Never>
        let startButtonEnabled: AnyPublisher<Bool, Never>
        let signUpResult: AnyPublisher<Void, Never>
    }

    // MARK: - Private

    private let useCase: OnBoardingUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let navigateToHomeSubject = PassthroughSubject<Void, Never>()
    private var latestValidNickname: String = ""
    public var selectedImageData: Data?
    private var latestFileKey: String = ""

    // MARK: - Init

    public init(useCase: OnBoardingUseCase, uploadImageUseCase: UploadImageUseCase) {
        self.useCase = useCase
        self.uploadImageUseCase = uploadImageUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        let nicknameChanged = input.nicknameChanged
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] nickname in
                self?.latestValidNickname = nickname
            })
            .share()

        let nicknameValidatoinState = nicknameChanged
            .map { [weak self] nickname -> TextField.State in
                guard let self else { return .normal }

                switch useCase.validate(nickname) {
                case .empty:
                    return .normal
                case .tooShort:
                    return .error("최소 2글자 이상 입력해주세요")
                case .containsInvalidCharacters:
                    return .error("특수문자, 이모지는 사용이 불가능해요")
                case .valid:
                    return .wait
                }
            }

        let nicknameDupicateState = nicknameChanged
            .filter { [weak self] in self?.useCase.validate($0) == .valid }
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .map { nickname in
                self.useCase.checkDuplicate(nickname)
                    .map { (isAvailable, message) in
                        if isAvailable {
                            return (nickname, TextField.State.success(message ?? "사용 가능한 닉네임이에요"))
                        } else {
                            return (nickname, TextField.State.error(message ?? "이미 사용 중인 닉네임이에요."))
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .combineLatest(nicknameChanged)
            .compactMap { response, currentNickname in
                let (responseNickname, state) = response
                return responseNickname == currentNickname ? state : nil
            }


        let nicknameState = Publishers.Merge(nicknameValidatoinState, nicknameDupicateState)
            .share()

        let isStartButtonEnabled = nicknameState
            .map {
                if case .success = $0 {
                    return true
                } else {
                    return false
                }
            }

        input.startTapped
            .flatMap { [weak self] adAgree -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }

                let imageData = self.selectedImageData
                let contentType = "image/jpeg"

                // 이미지가 있는 경우 → PresignedURL 후 업로드
                if let data = imageData {
                    return self.uploadImageUseCase
                        .execute(data: data, contentType: contentType, purpose: "PROFILE_UPLOAD")
                        .flatMap { fileKey in
                            self.useCase.registerProfile(
                                nickname: self.latestValidNickname,
                                adAlarmAgree: adAgree,
                                fileKey: fileKey
                            )
                        }
                        .handleEvents(receiveOutput: { [weak self] in
                            UserDefaults.standard.set(true, forKey: "isProfileCompleted")
                            self?.navigateToHomeSubject.send()
                        })
                        .catch { _ in Empty() }
                        .eraseToAnyPublisher()
                } else {
                    return self.useCase.registerProfile(
                        nickname: self.latestValidNickname,
                        adAlarmAgree: adAgree,
                        fileKey: nil
                    )
                    .handleEvents(receiveOutput: { [weak self] in
                        UserDefaults.standard.set(true, forKey: "isProfileCompleted")
                        self?.navigateToHomeSubject.send()
                    })
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
                }
            }
            .sink { _ in }
            .store(in: &cancellables)

        return Output(
            nicknameState: nicknameState.eraseToAnyPublisher(),
            startButtonEnabled: isStartButtonEnabled.eraseToAnyPublisher(),
            signUpResult: navigateToHomeSubject.eraseToAnyPublisher()
        )
    }
}
