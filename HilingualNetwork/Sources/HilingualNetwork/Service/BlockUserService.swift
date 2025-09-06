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
public final class MockBlockUserService: BaseService<MyPageAPI>, BlockUserService {

    private var mockDTOs: [BlockedUserDTO] = BlockedUserListResponseDTO.sampleData.blockList

    public init() {}

    public func fetchBlockedUsers() -> AnyPublisher<BlockedUserListResponseDTO, Error> {
        return request(.fetchBlockUserList, as: BaseAPIResponse<BlockedUserListResponseDTO>.self)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func unblockUser(id: Int) -> AnyPublisher<Void, Error> {
        mockDTOs.removeAll { $0.userId == id }
        return Just(())
            .delay(for: .milliseconds(200), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func blockUser(id: Int) -> AnyPublisher<Void, Error> {
        let newMock = BlockedUserDTO(userId: id, profileImg: "", nickname: "새 유저 \(id)")
        mockDTOs.append(newMock)
        return Just(())
            .delay(for: .milliseconds(200), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
