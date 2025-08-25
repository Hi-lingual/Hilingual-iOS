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

    // MARK: - Fetch

    private func fetchBlockedUsers() {
        blockUserUseCase.fetchBlockedUsers()
            .map { users in
                users.map {
                    BlockedUserModel(
                        userId: $0.userId,
                        nickname: $0.nickname,
                        profileImg: $0.profileImg,
                        isBlocked: $0.isBlocked
                    )
                }
            }
            .replaceError(with: [])
            .sink { [weak self] models in
                self?.blockedUsersSubject.send(models)
            }
            .store(in: &cancellables)
    }


    // MARK: - Toggle

    private func toggleBlockState(for userId: Int) {
        guard let user = blockedUsersSubject.value.first(where: { $0.userId == userId }) else { return }

        if user.isBlocked {
            unblockUser(userId: userId)
        } else {
            blockUser(userId: userId)
        }
    }

    // MARK: - Block / Unblock

    private func unblockUser(userId: Int) {
        blockUserUseCase.unblockUser(id: userId)
            .sink(receiveCompletion: { [weak self] completion in
                if case .finished = completion {
                    self?.updateUserBlockState(userId: userId, isBlocked: false)
                    print("차단 해제 성공")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    private func blockUser(userId: Int) {
        blockUserUseCase.blockUser(id: userId)
            .sink(receiveCompletion: { [weak self] completion in
                if case .finished = completion {
                    self?.updateUserBlockState(userId: userId, isBlocked: true)
                    print("차단 성공")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    // MARK: - Local State Update

    private func updateUserBlockState(userId: Int, isBlocked: Bool) {
        let updated = blockedUsersSubject.value.map { user -> BlockedUserModel in
            if user.userId == userId {
                var newUser = user
                newUser.isBlocked = isBlocked
                return newUser
            } else {
                return user
            }
        }
        blockedUsersSubject.send(updated)
    }
}
