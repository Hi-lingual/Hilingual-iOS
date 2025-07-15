////
////  TokenRefreshManager.swift
////  HilingualNetwork
////
////  Created by 성현주 on 7/15/25.
////
//
//
//import Foundation
//import Combine
//import Moya
//
//final class TokenRefreshManager {
//    static let shared = TokenRefreshManager()
//
//    private let lock = NSLock()
//    private var isRefreshing = false
//    private var waiting: [() -> Void] = []
//
//    private init() {}
//
//    func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
//        lock.lock()
//
//        if isRefreshing {
//            waiting.append { completion(true) }
//            lock.unlock()
//            return
//        }
//
//        isRefreshing = true
//        lock.unlock()
//
//        let provider = MoyaProvider<AuthAPI>(plugins: [])
//        provider.request(.refreshToken(refreshToken: UserDefaultHandler.refreshToken)) { result in
//            self.lock.lock(); defer { self.lock.unlock() }
//
//            self.isRefreshing = false
//
//            switch result {
//            case .success(let response):
//                print("[TokenRefreshManager] 📦 응답 바디:\n" + (String(data: response.data, encoding: .utf8) ?? "데이터 없음"))
//
//                do {
//                    let decoded = try response.map(BaseAPIResponse<TokenRefreshResponseDTO>.self)
//                    UserDefaultHandler.accessToken = decoded.data.accessToken
//                    UserDefaultHandler.refreshToken = decoded.data.refreshToken
//
//                    print("[TokenRefreshManager] ✅ 토큰 재발급 성공")
//                    self.waiting.forEach { $0() }
//                    self.waiting.removeAll()
//                    completion(true)
//                } catch {
//                    print("[TokenRefreshManager] ❌ 디코딩 실패: \(error)")
//                    completion(false)
//                }
//
//            case .failure:
//                print("[TokenRefreshManager] ❌ 토큰 재발급 실패")
//                completion(false)
//            }
//        }
//    }
//}
