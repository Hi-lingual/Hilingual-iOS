//
//  NetworkError+HilingualError.swift
//  HilingualNetwork
//
//  Created by 성현주 on 6/27/26.
//

// 네트워크 계층의 구체 에러(NetworkError)를 앱 전역 도메인 에러(HilingualError)로 변환한다.
// "어떤 응답을 '존재하지 않는 데이터'로 볼 것인가" 같은 분류 정책이 이 한 곳에 모인다.

import Foundation
import HilingualCore

extension NetworkError {

    func toHilingualError() -> HilingualError {
        switch self {
        case .notFound:
            return .dataNotFound

        case .unauthorized, .refreshFailed:
            return .unauthorized

        case .networkFail:
            return .network

        case .serverError(let serverError):
            return DataNotFoundPolicy.contains(code: serverError.code) ? .dataNotFound : .server

        case .timeout, .decoding, .unknown, .forbidden:
            return .server
        }
    }
}

/// '존재하지 않는 데이터'(데이터 없음 페이지/팝업)로 취급할 서버 비즈니스 코드 정책.
/// 사용자가 들어간 콘텐츠/엔티티 자체가 존재하지 않는 경우만 포함한다.
/// 백엔드 코드가 추가/변경되면 이 집합만 고치면 전 화면에 반영된다.
///
/// 주의: HTTP 404 라도 정상 빈 상태(예: 40405 해당 날짜 일기 없음)나
/// 인증/엔드포인트 오류(40400~40402, 40406~40408)는 여기 포함하지 않는다 → 서버 오류로 처리.
enum DataNotFoundPolicy {
    private static let codes: Set<Int> = [
        40403,
        40404,
        40409,
        40410,
        40411,
        40412
    ]

    static func contains(code: Int) -> Bool {
        codes.contains(code)
    }
}
