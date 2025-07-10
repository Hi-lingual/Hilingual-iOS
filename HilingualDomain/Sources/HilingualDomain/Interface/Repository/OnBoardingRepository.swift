//
//  NicknameRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/8/25.
//

import Foundation
import Combine

public protocol OnBoardingRepository {
    func isNicknameAvailable(_ nickname: String) -> AnyPublisher<Bool, Error>
    //func checkDuplicate(_ nickname: String) -> AnyPublisher<Bool, Error>
}

//TODO: - Service 연결
