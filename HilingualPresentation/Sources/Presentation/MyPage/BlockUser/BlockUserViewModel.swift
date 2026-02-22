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

    // MARK: - Input

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let unblockTapped: AnyPublisher<Int, Never>
        let refreshTriggered: AnyPublisher<Void, Never>
    }

    //MARK: - Output

    public struct Output {
        let blockedUsers: AnyPublisher<[BlockedUserModel], Never>
    }

    // MARK: - Properties

    private let blockUserUseCase: BlockUserUseCase
    let blockedUsersSubject = CurrentValueSubject<[BlockedUserModel], Never>([])

    // MARK: - Init

    public init(blockUserUseCase: BlockUserUseCase) {
        self.blockUserUseCase = blockUserUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .merge(with: input.refreshTriggered)
            .sink { [weak self] in
                self?.fetchBlockedUsers()
            }
            .store(in: &cancellables)

        input.unblockTapped
            .sink { [weak self] userId in
                self?.toggleBlockState(for: userId)
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
                users.map {
                    BlockedUserModel(
                        userId: $0.userId,
                        nickname: $0.nickname,
                        profileImg: $0.profileImg,
                        buttonState: $0.isBlocked ? .unblock : .block
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
                if case .finished = completion {
                    self?.updateUserBlockState(userId: userId, isBlocked: false)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    private func blockUser(userId: Int) {
        blockUserUseCase.blockUser(id: userId)
            .sink(receiveCompletion: { [weak self] completion in
                if case .finished = completion {
                    self?.updateUserBlockState(userId: userId, isBlocked: true)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    private func toggleBlockState(for userId: Int) {
        guard let user = blockedUsersSubject.value.first(where: { $0.userId == userId }) else { return }

        switch user.buttonState {
        case .unblock:
            unblockUser(userId: userId)
        case .block:
            blockUser(userId: userId)
        case .follow, .following, .mutualFollow:
            return
        }
    }

    private func updateUserBlockState(userId: Int, isBlocked: Bool) {
        let updated = blockedUsersSubject.value.map { user -> BlockedUserModel in
            if user.userId == userId {
                var newUser = user
                newUser = BlockedUserModel(
                    userId: user.userId,
                    nickname: user.nickname,
                    profileImg: user.profileImg,
                    buttonState: isBlocked ? .unblock : .block
                )
                return newUser
            } else {
                return user
            }
        }
        blockedUsersSubject.send(updated)
    }
}
