//
//  DiaryWritingViewController+ViewDelegate.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/31/25.
//

// MARK: Delegate

extension DiaryWritingViewController: DiaryWritingViewDelegate {
    func didTapCamera() {
        presentCamera()
        self.diaryWritingView.modal.isHidden = true
    }

    func didTapGallery() {
        presentImagePicker(mode: .normal) // 일반 이미지 선택기
        self.diaryWritingView.modal.isHidden = true
    }

    func didTapOCRGallery() {
        presentImagePicker(mode: .ocr)  // OCR용 이미지 선택기
        self.diaryWritingView.modal.isHidden = true
    }
    
    func didTapTemporarySave(text: String) {
        saveDraft()
    }

}
