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

    public struct Input {}

    public struct Output {
        public let userProfilePublisher: AnyPublisher<UserProfileEntity?, Never>
        public let profileImageUploadSuccess: AnyPublisher<Void, Never>
        public let profileImageUploadError: AnyPublisher<Error, Never>
    }

    // MARK: - Properties

    private let fetchUserProfileUseCase: FetchUserProfileUseCase
    private let uploadImageUseCase: UploadImageUseCase

    private let userProfileSubject = CurrentValueSubject<UserProfileEntity?, Never>(nil)
    private let profileImageUploadSuccessSubject = PassthroughSubject<Void, Never>()
    private let profileImageUploadErrorSubject = PassthroughSubject<Error, Never>()

    // MARK: - Init

    public init(
        fetchUserProfileUseCase: FetchUserProfileUseCase,
        uploadImageUseCase: UploadImageUseCase
    ) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.uploadImageUseCase = uploadImageUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        fetchUserProfile()

        return Output(
            userProfilePublisher: userProfileSubject.eraseToAnyPublisher(),
            profileImageUploadSuccess: profileImageUploadSuccessSubject.eraseToAnyPublisher(),
            profileImageUploadError: profileImageUploadErrorSubject.eraseToAnyPublisher()
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
