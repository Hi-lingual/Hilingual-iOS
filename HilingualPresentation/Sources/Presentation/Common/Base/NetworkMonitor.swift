//
//  NetworkMonitor.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

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
