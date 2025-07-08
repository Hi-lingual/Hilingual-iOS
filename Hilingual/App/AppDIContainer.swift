//
//  AppDIContainer.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import HilingualDomain
import HilingualData
import HilingualNetwork
import HilingualPresentation

// MARK: - DIContainer Entry Point

final class AppDIContainer: ViewControllerFactory {

    static let shared = AppDIContainer()
    private init() { }

    public func makeTabBarViewController() -> HilingualPresentation.TabBarViewController {
        return TabBarViewController(diContainer: self)
    }

    public func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(), diContainer: self)
    }

    public func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel(), diContainer: self)
    }

}


// MARK: - LoginDIContainer

extension AppDIContainer {
    ///로그인 DIContainer는 지금 뷰모델에 유스케이스가 없어서 간단한겁니다
    private func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel()
    }

}


// MARK: - HomeDIContainer

extension AppDIContainer {

    private func makeHomeService() -> HomeService {
        return DefaultHomeService()
    }

    private func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(service: makeHomeService())
    }

    private func makeHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(repository: makeHomeRepository())
    }

    private func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(useCase: makeHomeUseCase())
    }
}
