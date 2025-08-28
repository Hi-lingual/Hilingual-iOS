//
//  BlockUserUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/21/25.
//

import Combine

public protocol BlockUserUseCase {
    func fetchBlockedUsers() -> AnyPublisher<[BlockedUserEntity], Error>
    func unblockUser(id: Int) -> AnyPublisher<Void, Error>
    func blockUser(id: Int) -> AnyPublisher<Void, Error>
}

public final class DefaultBlockUserUseCase: BlockUserUseCase {

    private let repository: BlockUserRepository

    public init(repository: BlockUserRepository) {
        self.repository = repository
    }

    public func fetchBlockedUsers() -> AnyPublisher<[BlockedUserEntity], Error> {
        return repository.fetchBlockedUsers()
    }

    public func unblockUser(id: Int) -> AnyPublisher<Void, Error> {
        return repository.unblockUser(id: id)
    }

    public func blockUser(id: Int) -> AnyPublisher<Void, Error> {
        return repository.blockUser(id: id) 
    }
}
