//
//  DiaryDetailViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import Foundation
import Combine

public final class DiaryDetailViewModel: BaseViewModel {
    private let diaryId: Int

    public init(diaryId: Int) {
        self.diaryId = diaryId
    }
}
