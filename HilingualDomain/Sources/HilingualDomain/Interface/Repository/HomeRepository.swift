//
//  HomeRepository.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

//추상화된 레포지토리 실 구현은 data 레이어에 있어요
public protocol HomeRepository {
    func fetchUserInfo() -> AnyPublisher<UserInfoEntity, Error>
}
