//
//  DiaryWritingViewcontroller+TemporarySave.swift
//  HilingualPresentation
//
//  Created by 진소은 on 11/12/25.
//

import UIKit

extension DiaryWritingViewController {
    func saveDraft(text: String) {
        let image = diaryWritingView.selectedImageView.image

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && image == nil {
            print("내용을 입력하세요")
            return
        }

        viewModel?.didTapTemporarySave(
            text: text,
            date: selectedDate,
            imageData: image?.jpegData(compressionQuality: 0.8)
        )
    }
}
