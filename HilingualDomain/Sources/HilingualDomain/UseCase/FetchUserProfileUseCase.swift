//
//  FetchUserProfileUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 9/9/25.
//

import Combine

public protocol FetchUserProfileUseCase {
    func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error>
    func updateProfileImage(fileKey: String) -> AnyPublisher<Void, Error>
}

public final class DefaultFetchUserProfileUseCase: FetchUserProfileUseCase {
    private let repository: UserProfileRepository
    
    public init(repository: UserProfileRepository) {
        self.repository = repository
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error> {
        return repository.fetchMyProfile()
    }

    public func updateProfileImage(fileKey: String) -> AnyPublisher<Void, Error> {
        return repository.updateProfileImage(fileKey: fileKey)
    }
}
