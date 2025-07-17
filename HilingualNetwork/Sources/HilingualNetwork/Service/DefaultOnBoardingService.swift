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

public final class DefaultOnBoardingService: BaseService<OnBoardingAPI>,OnBoardingService {

    //TODO: - null 리스폰스 변경
    public func registerProfile(nickname: String, profileImg: String) -> AnyPublisher<Void, Error> {
        return requestPlain(
            .setProfile(nickname: nickname, profileImg: profileImg)
        )
        .map { _ in () }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }


    public func checkNicknameDuplication(nickname: String) -> AnyPublisher<Bool, Error> {
           return request(.checkNickname(nickname: nickname), as: OnBoardingResponseDTO.self)
            .map { $0.data.isAvailable }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
       }

}
