//
//  HomeViewModel.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

import HilingualDomain

public final class HomeViewModel: BaseViewModel {

    // MARK: - Input

    struct Input {
    }

    // MARK: - Output

    struct Output {
    }

    // MARK: - Properties

    private let useCase: HomeUseCase

    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform
}

