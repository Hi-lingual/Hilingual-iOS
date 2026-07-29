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
    func checkNicknameDuplication(nickname: String) -> AnyPublisher<OnBoardingResponseDTO, Error>
    func registerProfile(nickname: String, adAlarmAgree: Bool, fileKey: String?) -> AnyPublisher<Int64, Error>
}

public final class DefaultOnBoardingService: BaseService<OnBoardingAPI>, OnBoardingService {
    public func registerProfile(nickname: String, adAlarmAgree: Bool, fileKey: String?) -> AnyPublisher<Int64, Error> {
        let dto = RegisterProfileRequestDTO(nickname: nickname, adAlarmAgree: adAlarmAgree, fileKey: fileKey)
        return request(.registerProfile(requestDTO: dto), as: BaseAPIResponse<RegisterProfileResponseDTO>.self)
            .map { $0.data.userId }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func checkNicknameDuplication(nickname: String) -> AnyPublisher<OnBoardingResponseDTO, Error> {
        return request(.checkNickname(nickname: nickname), as: OnBoardingResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
