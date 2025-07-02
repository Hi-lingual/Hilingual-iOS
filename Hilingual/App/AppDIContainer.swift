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

    // MARK: - Network
    private func makeHomeService() -> HomeServiceProtocol {
        return HomeService()
    }

    // MARK: - Repository
    private func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(service: makeHomeService())
    }

    // MARK: - UseCase
    private func makeHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(repository: makeHomeRepository())
    }

    // MARK: - ViewModel
    private func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(useCase: makeHomeUseCase())
    }

    // MARK: - Entry Point
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }
}
