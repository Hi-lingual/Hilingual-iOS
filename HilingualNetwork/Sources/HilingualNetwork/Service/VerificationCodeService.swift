//
//  VerificationCodeService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/14/25.
//

import Foundation
import Combine

public protocol VerificationCodeService {
    func verifyCode(code: String) -> AnyPublisher<Void, Error>
}

public final class MockVerificationCodeService: VerificationCodeService {
    public init() {}

    public func verifyCode(code: String) -> AnyPublisher<Void, Error> {
        // 여기서 네트워크 없이 테스트 응답
        return Future<Void, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if code == "123456" {
                    promise(.success(()))
                } else {
                    promise(.failure(MockError.invalidCode))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public enum MockError: LocalizedError {
        case invalidCode

        public var errorDescription: String? {
            switch self {
            case .invalidCode:
                return "유효하지 않은 인증코드입니다."
            }
        }
    }
}
