//
//  HomeService.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import Moya
import Combine

public protocol HomeService {
    func fetchUserInfo() -> AnyPublisher<UserInfoDTO, Error>
}

public final class DefaultHomeService: BaseService<HomeAPI>, HomeService {
    public func fetchUserInfo() -> AnyPublisher<UserInfoDTO, Error> {
        return request(.getUserInfo, as: UserInfoDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
