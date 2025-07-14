//
//  OnBoardingUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/8/25.
//

import Foundation
import Combine

public protocol OnBoardingUseCase {
    func validate(_ nickname: String) -> NicknameValidationResult
    func checkDuplicate(_ nickname: String) -> AnyPublisher<Bool, Error>
    func registerProfile(nickname: String, profileImg: String) -> AnyPublisher<Void, Error>
}

public final class DefaultOnBoardingUseCase: OnBoardingUseCase {
    private let onBoardingRepository: OnBoardingRepository

    public init(onBoardingRepository: OnBoardingRepository) {
        self.onBoardingRepository = onBoardingRepository
    }


    public func validate(_ nickname: String) -> NicknameValidationResult {
        if nickname.isEmpty {
            return .empty
        } else if nickname.count < 2 {
            return .tooShort
        } else if nickname.containsSpecialOrEmoji {
            return .containsInvalidCharacters
        } else {
            return .valid
        }
    }

    public func checkDuplicate(_ nickname: String) -> AnyPublisher<Bool, Error> {
        return onBoardingRepository.isNicknameAvailable(nickname)
    }

    public func registerProfile(nickname: String, profileImg: String) -> AnyPublisher<Void, Error> {
           let entity = ProfileEntity(nickname: nickname, profileImg: profileImg)
           return onBoardingRepository.registerProfile(profile: entity)
       }

}

//MARK: - Extension

public extension String {
    var containsSpecialOrEmoji: Bool {
        let regex = "[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]"
        return range(of: regex, options: .regularExpression) != nil
    }
}
