//
//  DiaryWritingViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/8/25.
//

import Foundation
import Combine

import PhotosUI

public final class DiaryWritingViewController: BaseUIViewController<DiaryWritingViewModel>, TextViewDelegate {
    
    // MARK: - Properties
    
    private let diaryWritingView = DiaryWritingView()
    private let textCountSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubviews(diaryWritingView)
    }
    
    public override func setLayout() {
        diaryWritingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func addTarget() {
        diaryWritingView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    @objc private func cameraButtonTapped() {
        presentImagePicker()
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return .backTitle("일기 작성하기")
    }
    
    // MARK: - Bind
    
    public override func bind(viewModel: DiaryWritingViewModel) {
        super.bind(viewModel: viewModel)
        
        diaryWritingView.textView.delegate = self
        
        let input = DiaryWritingViewModel.Input(textCount: textCountSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        bindOutput(output)
    }
    
    private func bindOutput(_ output: DiaryWritingViewModel.Output) {
        output.buttonActive
            .receive(on: RunLoop.main)
            .sink { [weak self] isActive in
                guard let self = self else { return }
                self.diaryWritingView.feedbackButton.isEnabled = isActive
                self.diaryWritingView.tooltip.isHidden = isActive
            }
            .store(in: &cancellables)
    }
    
    func textView(_ textView: TextView, didChangeTextCount count: Int) {
        textCountSubject.send(count)
    }
}

extension DiaryWritingViewController: PHPickerViewControllerDelegate {
    func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self?.diaryWritingView.setImage(image)
            }
        }
    }
}
