//
//  DefaultFollowListRepository.swift
//  HilingualData
//
//  Created by 신혜연 on 8/17/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultFollowListRepository: FollowListRepository {
    
    private var service: FollowListService
    
    public init(service: FollowListService) {
        self.service = service
    }
}
