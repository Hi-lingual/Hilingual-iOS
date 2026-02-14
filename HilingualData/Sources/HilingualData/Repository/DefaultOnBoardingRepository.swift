//
//  DefaultOnBoardingRepository.swift
//  HilingualData
//
//  Created by 성현주 on 7/8/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultOnBoardingRepository: OnBoardingRepository {

    private let service: OnBoardingService

    public init(service: OnBoardingService) {
        self.service = service
    }
    
    public func isNicknameAvailable(_ nickname: String) -> AnyPublisher<(Bool, String?), Never> {
        service.checkNicknameDuplication(nickname: nickname)
            .map { dto in
                return (dto.data.isAvailable, dto.message)
            }
            .replaceError(with: (false, "중복 확인 중 오류가 발생했어요."))
            .eraseToAnyPublisher()
    }

    public func registerProfile(profile: ProfileEntity) -> AnyPublisher<Void, Error> {
        return service.registerProfile(
            nickname: profile.nickname,
            adAlarmAgree: profile.adAlarmAgree,
            fileKey: profile.image?.fileKey
        )
    }
}

