//
//  AppDIContainer.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

final class AppDIContainer {

    static let shared = AppDIContainer()
    private init() { }

    // MARK: - Domain Containers

    private(set) var homeDIContainer = HomeDIContainer.shared

    // MARK: - Entry Point

    func makeHomeViewController() -> HomeViewController {
        return homeDIContainer.makeHomeViewController()
    }

    // 이후 각 화면별 생성 진입점도 여기에 선언하시면 됩니다.
}
