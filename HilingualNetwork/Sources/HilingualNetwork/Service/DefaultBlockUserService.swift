//
//  BlockUserService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/21/25.
//

import Foundation
import Combine

public protocol BlockUserService {
    func fetchBlockedUsers() -> AnyPublisher<BlockedUserListResponseDTO, Error>
    func unblockUser(id: Int) -> AnyPublisher<Void, Error>
    func blockUser(id: Int) -> AnyPublisher<Void, Error>
}

//TODO: - mock으로 바꿔야함
public final class MockBlockUserService: BaseService<BlockUserAPI>, BlockUserService {

    private var mockDTOs: [BlockedUserDTO] = BlockedUserListResponseDTO.sampleData.blockList

    public init() {}

    public func fetchBlockedUsers() -> AnyPublisher<BlockedUserListResponseDTO, Error> {
        return request(.fetchBlockUserList, as: BaseAPIResponse<BlockedUserListResponseDTO>.self)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func unblockUser(id: Int) -> AnyPublisher<Void, Error> {
        return requestPlain(.unblockUser(userId: id))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func blockUser(id: Int) -> AnyPublisher<Void, Error> {
        return requestPlain(.blockUser(userId: id))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
