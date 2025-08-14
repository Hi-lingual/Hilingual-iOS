//
//  DiaryWritingViewController+VisionKitManager.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/31/25.
//

// MARK: OCR 결과, 에러 처리

extension DiaryWritingViewController: VisionKitManagerDelegate {
    func didRecognizeText(_ text: String) {
        let limitedText = String(text.prefix(diaryWritingView.textView.maxCharacterCount))
        diaryWritingView.setText(limitedText)
    }
    
    func didFailWithError(_ message: String) {
        showErrorDialog()
    }
}
