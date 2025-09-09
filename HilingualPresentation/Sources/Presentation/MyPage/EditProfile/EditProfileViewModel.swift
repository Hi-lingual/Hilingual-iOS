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
    }

    // MARK: - Properties

    private let fetchUserProfileUseCase: FetchUserProfileUseCase
    private let userProfileSubject = CurrentValueSubject<UserProfileEntity?, Never>(nil)

    // MARK: - Init

    public init(fetchUserProfileUseCase: FetchUserProfileUseCase) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        fetchUserProfile()

        return Output(
            userProfilePublisher: userProfileSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private

    private func fetchUserProfile() {
        fetchUserProfileUseCase.fetchMyProfile()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // TODO: 에러 처리 필요시 여기에
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
