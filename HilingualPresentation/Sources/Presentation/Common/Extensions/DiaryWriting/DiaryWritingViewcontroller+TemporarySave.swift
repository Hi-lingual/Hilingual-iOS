//
//  DiaryWritingViewcontroller+TemporarySave.swift
//  HilingualPresentation
//
//  Created by 진소은 on 11/12/25.
//

import UIKit

extension DiaryWritingViewController {
    func saveDraft() {

        let text = diaryWritingView.textView.text
        let imageData = diaryWritingView.selectedImageView.image?.jpegData(compressionQuality: 0.8)
        self.imageData = imageData

        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isImageChanged() == true {
            self.showDraftDialogIfBarTap()
        } else if trimmed == "" || self.initialText == self.diaryWritingView.textView.text {
            self.diaryWritingView.showToast(message: "내용을 입력하세요.")
        } else if self.initialText != self.diaryWritingView.textView.text {
            self.showDraftDialogIfBarTap()
        } else {
            viewModel?.didTapTemporarySave(
                text: text,
                date: selectedDate,
                imageData: imageData
            )
            self.diaryWritingView.showToast(message: "임시저장이 완료되었어요.")
        }
    }
}
