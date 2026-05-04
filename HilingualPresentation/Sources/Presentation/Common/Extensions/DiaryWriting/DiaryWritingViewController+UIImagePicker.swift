//
//  DiaryWritingViewController+UIImagePicker.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/31/25.
//

import UIKit

// MARK: 카메라 촬영

extension DiaryWritingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(
                title: "카메라 사용 불가",
                message: "카메라를 사용할 수 없습니다. 설정에서 권한을 확인해주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            visionKitManager.handleOCRImage(image)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
