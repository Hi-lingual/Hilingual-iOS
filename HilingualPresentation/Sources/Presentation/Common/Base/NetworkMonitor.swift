//
//  NetworkMonitor.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

// 앱 전역 네트워크 연결 상태(온/오프라인)를 하나의 인스턴스로 추적한다.
// 화면 이동 전 "이미 끊긴 상태"인지 판단(NetworkAwareNavigationController)에 사용된다.

import Foundation
import Network

@MainActor
final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "HilingualNetworkMonitor")

    private(set) var isOffline = false

    private init() {
        monitor.pathUpdateHandler = { path in
            let offline = (path.status != .satisfied)
            Task { @MainActor in
                NetworkMonitor.shared.isOffline = offline
            }
        }
        monitor.start(queue: queue)
    }

    func start() {}
}
