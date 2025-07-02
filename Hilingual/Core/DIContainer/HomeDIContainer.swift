//
//  HomeDIContainer.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

final class HomeDIContainer {

    static let shared = HomeDIContainer()
    private init() { }

    // MARK: - Network
    private func makeHomeService() -> HomeService {
        return DefaultHomeService()
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
