//
//  VisionKitManager.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/15/25.
//

import UIKit
import Vision
import VisionKit

@MainActor
protocol VisionKitManagerDelegate: AnyObject {
    func didRecognizeText(_ text: String)
}

@MainActor
final class VisionKitManager: NSObject {

    weak var delegate: VisionKitManagerDelegate?

    private let textRecognitionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["ko-KR", "en-US"]
        return request
    }()

    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("❌ cgImage 변환 실패")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([textRecognitionRequest])
            guard let observations = textRecognitionRequest.results else {
                print("❌ 텍스트 인식 결과가 없음")
                return
            }
            
            let recognizedText = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
            print("✅ 인식된 텍스트:\n\(recognizedText)")
            
            Task {
                self.delegate?.didRecognizeText(recognizedText)
            }
        } catch {
            print("❌ 텍스트 인식 실패: \(error.localizedDescription)")
        }
    }
    
    func handleOCRImage(_ image: UIImage) {
        let compressedImage = compressImageIfNeeded(image)
        recognizeText(from: compressedImage)
    }
    
    @MainActor
    func presentCamera(from viewController: UIViewController) {
        guard VNDocumentCameraViewController.isSupported else {
            print("카메라 스캔 미지원")
            return
        }

        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        viewController.present(scanner, animated: true)
    }
    
    private func compressImageIfNeeded(_ image: UIImage, maxSizeMB: Double = 10) -> UIImage {
        let maxSizeBytes = maxSizeMB * 1024 * 1024
        var compressionQuality: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        
        if let data = imageData {
            print("📸 원본 이미지 크기: \(Double(data.count) / 1024 / 1024) MB")
        }
        
        while let data = imageData, Double(data.count) > maxSizeBytes, compressionQuality > 0.1 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }
        
        if let data = imageData {
            print("📉 압축된 이미지 크기: \(Double(data.count) / 1024 / 1024) MB (quality: \(compressionQuality))")
        }
        
        if let compressedData = imageData, let compressedImage = UIImage(data: compressedData) {
            return compressedImage
        }
        return image
    }
}

extension VisionKitManager: @preconcurrency VNDocumentCameraViewControllerDelegate {
    @MainActor func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) { [weak self] in
            guard scan.pageCount > 0 else { return }
            let image = scan.imageOfPage(at: 0)
            self?.recognizeText(from: image)
        }
    }

    @MainActor func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    @MainActor func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }
}
