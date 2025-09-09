//
//  DefaultUserProfileRepository.swift
//  HilingualData
//
//  Created by 성현주 on 9/9/25.
//

import Combine
import HilingualDomain
import HilingualNetwork
import Foundation

public final class DefaultUserProfileRepository: UserProfileRepository {
    private let service: UserProfileService
    
    public init(service: UserProfileService) {
        self.service = service
    }
    
    public func fetchMyProfile() -> AnyPublisher<UserProfileEntity, Error> {
        return service.fetchMyProfile()
            .map { $0.toEntity() }
            .eraseToAnyPublisher()
    }
}
