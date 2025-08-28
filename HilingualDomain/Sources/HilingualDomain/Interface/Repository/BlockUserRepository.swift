//
//  BlockUserRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/21/25.
//

import Foundation
import Combine

public protocol BlockUserRepository {
    func fetchBlockedUsers() -> AnyPublisher<[BlockedUserEntity], Error>
    func unblockUser(id: Int) -> AnyPublisher<Void, Error>
    func blockUser(id: Int) -> AnyPublisher<Void, Error>
}
