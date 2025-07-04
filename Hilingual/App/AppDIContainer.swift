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

final class AppDIContainer: DIContainer {

    static let shared = AppDIContainer()
    private init() { }

    public func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }

    public func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel()
        return LoginViewController(viewModel: viewModel, diContainer: self)
    }

}


// MARK: - LoginDIContainer

extension AppDIContainer {
    ///로그인 DIContainer는 지금 뷰모델에 유스케이스가 없어서 간단합겁니다

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
