//
//  DiaryDetailViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import Foundation
import Combine

public final class DiaryDetailViewModel: BaseViewModel {
    
    public let diaryId: Int

    // MARK: - Init
    
    public init(diaryId: Int) {
        print("📝 DiaryDetailViewModel 초기화, diaryId: \(diaryId)")
        self.diaryId = diaryId
        super.init()
    }
}
