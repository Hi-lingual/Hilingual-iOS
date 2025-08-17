//
//  FollowListUseCase.swift
//  HilingualDomain
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

public protocol FollowListUseCase {

}

public final class DefaultFollowListUseCase: FollowListUseCase {
    
    private let repository: FollowListRepository
    
    public init(repository: FollowListRepository) {
        self.repository = repository
    }
}
