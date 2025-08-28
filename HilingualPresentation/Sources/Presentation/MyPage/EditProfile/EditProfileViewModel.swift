//
//  EditProfileViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/20/25.
//

import Combine
import Foundation
import HilingualDomain

public final class EditProfileViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
    }

    // MARK: - Output

    public struct Output {

    }

    // MARK: - Properties

    private let mypageUseCase: MypageUseCase

    // MARK: - Init

    public init(mypageUseCase: MypageUseCase) {
        self.mypageUseCase = mypageUseCase
    }

    // MARK: - Transform

}
