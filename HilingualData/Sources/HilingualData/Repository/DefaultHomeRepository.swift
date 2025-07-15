//
//  DefaultHomeRepository.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

/// HomeRepository 프로토콜을 구현한 클래스
/// - 역할: Network로부터 받은 DTO를 도메인 모델(Entity)로 변환하여 전달하는 녀석입니다!
public final class DefaultHomeRepository: HomeRepository {

    /// 외부 API 요청을 수행하는 서비스 => 네트워크 모듈로 분리
    private let service: HomeService

    ///생성자 주입
    public init(service: HomeService) {
        self.service = service
    }

    /// - 반환: 도메인 모델(HomeEntity)을 Publisher로 반환
    public func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error> {
        return service.fetchUserInfo()
            .tryMap { dto in
                guard let data = dto.data else {
                    throw NetworkError.decoding
                }

                return UserInfoEntity(
                    nickname: data.nickname,
                    profileImg: data.profileImg,
                    totalDiaries: data.totalDiaries,
                    streak: data.streak
                )
            }
            .eraseToAnyPublisher()
    }
}
