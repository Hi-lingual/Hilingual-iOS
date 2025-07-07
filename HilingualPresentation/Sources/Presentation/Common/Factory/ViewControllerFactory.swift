//
//  ViewControllerFactory.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

public protocol ViewControllerFactory {
    func makeTabBarViewController() -> TabBarViewController
    func makeLoginViewController() -> LoginViewController
    func makeHomeViewController() -> HomeViewController
}
