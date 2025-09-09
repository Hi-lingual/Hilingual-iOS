//
//  FetchUserProfileUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 9/9/25.
//

import Combine

public protocol FetchUserProfileUseCase {
    func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error>
}

public final class DefaultFetchUserProfileUseCase: FetchUserProfileUseCase {
    private let repository: UserProfileRepository
    
    public init(repository: UserProfileRepository) {
        self.repository = repository
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error> {
        return repository.fetchMyProfile()
    }
}
