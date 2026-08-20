//
//  HomeAdWatchRepository.swift
//  HilingualDomain
//
//  Created by youngseo on 6/18/26.
//

import Combine

public protocol HomeAdWatchRepository {
    func postAdWatch(targetDate: String) -> AnyPublisher<Void, Error>
}
