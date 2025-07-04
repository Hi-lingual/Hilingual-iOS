//
//  DIContainer.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

public protocol DIContainer {
    func makeLoginViewController() -> LoginViewController
    func makeHomeViewController() -> HomeViewController
}
