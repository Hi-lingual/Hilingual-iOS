//
//  DiaryWritingViewController+PHPicker.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/31/25.
//

import PhotosUI

// MARK: 이미지 선택

extension DiaryWritingViewController: PHPickerViewControllerDelegate {
    
    func presentImagePicker(mode: PickerMode = .normal) {
        currentPickerMode = mode
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              let mode = currentPickerMode else {
            print("사용자가 선택하지 않고 닫음")
            return
        }
        
        // 이미지 타입 로드 불가일 때는 에러 다이얼로그
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("❌ 이미지 로드 불가")
            DispatchQueue.main.async {
                self.showErrorDialog(message: "이미지를 불러올 수 없습니다.")
            }
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ 이미지 로드 에러: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showErrorDialog(message: "이미지 로드 중 오류가 발생했습니다.")
                }
                return
            }
            
            guard let image = image as? UIImage else {
                print("❌ 이미지 변환 실패")
                DispatchQueue.main.async {
                    self.showErrorDialog(message: "이미지를 변환할 수 없습니다.")
                }
                return
            }
            
            DispatchQueue.main.async {
                switch mode {
                case .ocr:
                    self.visionKitManager.handleOCRImage(image)
                case .normal:
                    self.diaryWritingView.setImage(image)
                }
            }
        }
    }
}
