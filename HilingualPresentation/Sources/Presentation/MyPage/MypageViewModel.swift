//
//  MypageViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/20/25.
//

import Combine
import Foundation
import HilingualDomain

public final class MypageViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
    }

    // MARK: - Output

    public struct Output {

    }

    // MARK: - Properties

    private let useCase: HomeUseCase

    // MARK: - Init

    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    // MARK: - Additional Fetch Methods

}
