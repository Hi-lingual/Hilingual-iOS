//
//  DefaultOnBoardingService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/8/25.
//

import Foundation

import Moya
import Combine

public protocol OnBoardingService {
    func checkNicknameDuplication(nickname: String) -> AnyPublisher<Bool, Error>
    func registerProfile(nickname: String, profileImg: String) -> AnyPublisher<Void, Error>
}

public final class DefaultOnBoardingService: BaseService<OnBoardingAPI>, OnBoardingService {

    public func registerProfile(nickname: String, profileImg: String) -> AnyPublisher<Void, Error> {
        #if DEBUG
        // 디버그 모드에서는 성공 응답만 리턴하도록 했음
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        #else
        return requestPlain(
            .setProfile(nickname: nickname, profileImg: profileImg)
        )
        .map { _ in () }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
        #endif
    }

    public func checkNicknameDuplication(nickname: String) -> AnyPublisher<Bool, Error> {
        return request(.checkNickname(nickname: nickname), as: OnBoardingResponseDTO.self)
            .map { $0.data.isAvailable }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
