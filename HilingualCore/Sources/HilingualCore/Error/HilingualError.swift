//
//  HilingualError.swift
//  HilingualCore
//
//  Created by 성현주 on 6/27/26.
//

// 앱 전역에서 사용하는 에러 분류 타입.
// 네트워크/인프라 계층의 구체적인 에러(NetworkError, URLError 등)는
// Data·Network 경계에서 이 타입으로 변환되어 상위 계층으로 흐른다.
// Presentation 은 이 타입만 보고 에러 정책(표현 형태/문구/CTA)을 결정한다.

import Foundation

/// 기획 에러 정책의 4가지 분류와 1:1 대응되는 도메인 에러.
///
/// - `dataNotFound`: 존재하지 않는 데이터 조회 (탈퇴 유저, 공유 취소된 일기 등 / HTTP 404·약속된 비즈니스 코드)
/// - `network`: 인터넷 연결 불안정/끊김
/// - `server`: 서버 통신 오류 (5xx, 타임아웃, 디코딩 실패, 분류 불가 등 일시적 오류)
/// - `unauthorized`: 인증 만료. 세션 만료 흐름에서 별도 처리되므로 화면 에러 UI 대상이 아니다.
public enum HilingualError: Error, Equatable {
    case dataNotFound
    case network
    case server
    case unauthorized

    /// 분류 불가능한 임의의 `Error` 를 안전하게 도메인 에러로 흡수한다.
    /// 이미 `HilingualError` 면 그대로, 아니면 일시적 서버 오류(`.server`)로 본다.
    /// (예: Data 계층에서 던지는 디코딩 실패 등은 정책상 서버 오류로 취급)
    public static func from(_ error: Error) -> HilingualError {
        (error as? HilingualError) ?? .server
    }
}
