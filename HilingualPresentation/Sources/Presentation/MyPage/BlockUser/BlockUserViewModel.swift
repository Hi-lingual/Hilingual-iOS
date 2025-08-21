//
//  BlockUserViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import Foundation
import Combine
import HilingualDomain

public final class BlockUserViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let unblockTapped: AnyPublisher<Int, Never>
        let refreshTriggered: AnyPublisher<Void, Never>
    }

    public struct Output {
        let blockedUsers: AnyPublisher<[BlockedUserModel], Never>
    }

    // MARK: - Dependencies

    private let blockUserUseCase: BlockUserUseCase

    // MARK: - State

    let blockedUsersSubject = CurrentValueSubject<[BlockedUserModel], Never>([])
    var originalBlockedUsers: [BlockedUserEntity] = []

    // MARK: - Init

    public init(blockUserUseCase: BlockUserUseCase) {
        self.blockUserUseCase = blockUserUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                self?.fetchBlockedUsers()
            }
            .store(in: &cancellables)

        input.refreshTriggered
            .sink { [weak self] in
                self?.fetchBlockedUsers()
            }
            .store(in: &cancellables)

        input.unblockTapped
            .sink { [weak self] userId in
                self?.unblockUser(userId: userId)
            }
            .store(in: &cancellables)

        return Output(
            blockedUsers: blockedUsersSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func fetchBlockedUsers() {
        blockUserUseCase.fetchBlockedUsers()
            .map { users in
                self.originalBlockedUsers = users
                return users.map {
                    BlockedUserModel(
                        userId: $0.userId,
                        nickname: $0.nickname,
                        profileImg: $0.profileImg,
                        buttonState: .unblock
                    )
                }
            }
            .replaceError(with: [])
            .sink { [weak self] models in
                self?.blockedUsersSubject.send(models)
            }
            .store(in: &cancellables)
    }

    private func unblockUser(userId: Int) {
        blockUserUseCase.unblockUser(id: userId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("차단 성공")
                case .failure(let error):
                    print("차단 해제 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

}
