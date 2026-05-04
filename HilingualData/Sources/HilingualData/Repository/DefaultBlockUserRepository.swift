//
//  DefaultBlockUserRepository.swift
//  HilingualData
//
//  Created by 성현주 on 8/21/25.
//

import Combine
import HilingualDomain
import HilingualNetwork

public final class DefaultBlockUserRepository: BlockUserRepository {

    private let service: BlockUserService

    public init(service: BlockUserService) {
        self.service = service
    }

    public func fetchBlockedUsers() -> AnyPublisher<[BlockedUserEntity], Error> {
        return service.fetchBlockedUsers()
            .map { $0.blockList.toEntityList() }
            .eraseToAnyPublisher()
    }

    public func unblockUser(id: Int) -> AnyPublisher<Void, Error> {
        return service.unblockUser(id: id)
    }

    public func blockUser(id: Int) -> AnyPublisher<Void, Error> {
        return service.blockUser(id: id)
    }
}
