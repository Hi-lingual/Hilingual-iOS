//
//  EditProfileViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/20/25.
//

import Combine
import Foundation
import HilingualDomain

public final class EditProfileViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let withdrawTapped: AnyPublisher<Void, Never>
    }

    public struct Output {
        public let userProfilePublisher: AnyPublisher<UserProfileEntity?, Never>
        public let profileImageUploadSuccess: AnyPublisher<Void, Never>
        public let profileImageUploadError: AnyPublisher<Error, Never>
        public let withdrawSuccess: AnyPublisher<Void, Never>
        public let withdrawError: AnyPublisher<Error, Never>
    }

    // MARK: - Properties

    private let fetchUserProfileUseCase: FetchUserProfileUseCase
    private let mypageUseCase: MypageUseCase
    private let uploadImageUseCase: UploadImageUseCase

    private let userProfileSubject = CurrentValueSubject<UserProfileEntity?, Never>(nil)
    private let profileImageUploadSuccessSubject = PassthroughSubject<Void, Never>()
    private let profileImageUploadErrorSubject = PassthroughSubject<Error, Never>()
    private let withdrawSuccessSubject = PassthroughSubject<Void, Never>()
    private let withdrawErrorSubject = PassthroughSubject<Error, Never>()

    // MARK: - Init

    public init(
        fetchUserProfileUseCase: FetchUserProfileUseCase,
        uploadImageUseCase: UploadImageUseCase,
        mypageUseCase: MypageUseCase
    ) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.mypageUseCase = mypageUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        fetchUserProfile()

        input.withdrawTapped
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.mypageUseCase.withdraw()
                    .handleEvents(
                        receiveOutput: { [weak self] in
                            self?.withdrawSuccessSubject.send(())
                        }, receiveCompletion: { [weak self] completion in
                            if case let .failure(error) = completion {
                                self?.withdrawErrorSubject.send(error)
                            }
                        }
                    )
                    .replaceError(with: ())
                    .eraseToAnyPublisher()
            }
            .sink { _ in }
            .store(in: &cancellables)

        return Output(
            userProfilePublisher: userProfileSubject.eraseToAnyPublisher(),
            profileImageUploadSuccess: profileImageUploadSuccessSubject.eraseToAnyPublisher(),
            profileImageUploadError: profileImageUploadErrorSubject.eraseToAnyPublisher(),
            withdrawSuccess: withdrawSuccessSubject.eraseToAnyPublisher(),
            withdrawError: withdrawErrorSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Public

    public func uploadProfileImage(data: Data) {
        let contentType = "image/jpeg"
        uploadImageUseCase
            .execute(data: data, contentType: contentType, purpose: "PROFILE_UPDATE")
            .flatMap { fileKey  in self.fetchUserProfileUseCase.updateProfileImage(fileKey: fileKey)
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.profileImageUploadSuccessSubject.send(())
                        self?.fetchUserProfile()
                    case .failure(let error):
                        self?.profileImageUploadErrorSubject.send(error)
                    }
                },
                receiveValue: { }
            )
            .store(in: &cancellables)
    }

    // MARK: - Private

    private func fetchUserProfile() {
        fetchUserProfileUseCase.fetchMyProfile()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ 유저 정보 불러오기 실패: \(error)")
                    }
                },
                receiveValue: { [weak self] profile in
                    self?.userProfileSubject.send(profile)
                }
            )
            .store(in: &cancellables)
    }
}
