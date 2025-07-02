//
//  DefaultHomeRepository.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

/// HomeRepository 프로토콜을 구현한 클래스
/// - 역할: Network로부터 받은 DTO를 도메인 모델(Entity)로 변환하여 전달하는 녀석입니다!
final class DefaultHomeRepository: HomeRepository {

    /// 외부 API 요청을 수행하는 서비스 => 네트워크 모듈로 분리
    private let service: HomeService

    ///생성자 주입
    init(service: HomeService) {
        self.service = service
    }

    /// 현재 환율 정보를 가져오는 함수
    /// - 반환: 도메인 모델(HomeEntity)을 Publisher로 반환
    func fetchCurrentRate() -> AnyPublisher<HomeEntity, Error> {
        return service.fetchExchangeRate() //네트워크 모듈로 부터 환율 정보를 가지고옴요
            .map { DTO in
                // DTO → Entity 변환 (Data Layer에서 수행하는게 맞습니다)
                HomeEntity(exchangeRate: DTO.data)
            }
            .eraseToAnyPublisher()
    }
}

