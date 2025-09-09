//
//  MypageViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/20/25.
//

import Combine
import Foundation
import HilingualDomain

public final class MypageViewModel: BaseViewModel {

    //TODO: - Default 이미지 처리 로직 추가

    // MARK: - Input

    public struct Input {
        let logoutTapped: AnyPublisher<Void, Never>
    }

    // MARK: - Output

    public struct Output {
        let logoutCompleted: AnyPublisher<Void, Never>
        let logoutError: AnyPublisher<Error, Never>
        let userProfile: AnyPublisher<UserProfileEntity?, Never>
    }

    // MARK: - Properties

    private let mypageUseCase: MypageUseCase
    private let fetchUserProfileUseCase: FetchUserProfileUseCase

    private let logoutCompletedSubject = PassthroughSubject<Void, Never>()
    private let logoutErrorSubject = PassthroughSubject<Error, Never>()
    private let userProfileSubject = PassthroughSubject<UserProfileEntity?, Never>()

    // MARK: - Init

    public init(mypageUseCase: MypageUseCase, fetchUserProfileUseCase: FetchUserProfileUseCase) {
        self.mypageUseCase = mypageUseCase
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        fetchUserProfile()

        input.logoutTapped
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return self.mypageUseCase.logout()
                    .handleEvents(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            self.logoutCompletedSubject.send(())
                        case .failure(let error):
                            self.logoutErrorSubject.send(error)
                        }
                    })
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .sink { _ in }
            .store(in: &cancellables)

        return Output(
            logoutCompleted: logoutCompletedSubject.eraseToAnyPublisher(),
            logoutError: logoutErrorSubject.eraseToAnyPublisher(),
            userProfile: userProfileSubject.eraseToAnyPublisher()
        )
    }

    func fetchUserProfile() {
        fetchUserProfileUseCase.fetchMyProfile()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                    }
                },
                receiveValue: { [weak self] profile in
                    self?.userProfileSubject.send(profile)
                }
            )
            .store(in: &cancellables)
    }

}
