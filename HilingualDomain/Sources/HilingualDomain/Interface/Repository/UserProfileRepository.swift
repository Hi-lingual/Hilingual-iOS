//
//  UserProfileRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 9/9/25.
//

import Combine

public protocol UserProfileRepository {
    func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error>
    func updateProfileImage(fileKey: String) -> AnyPublisher<Void, Error>
}
