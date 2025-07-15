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
    func registerProfile(profile: ProfileEntity) -> AnyPublisher<Void, Error>
}

