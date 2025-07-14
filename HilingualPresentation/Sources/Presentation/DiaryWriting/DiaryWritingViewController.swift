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
    private let dialog = Dialog()
    private let textCountSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubviews(diaryWritingView, dialog)
    }
    
    public override func setLayout() {
        diaryWritingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public override func addTarget() {
        diaryWritingView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    @objc private func cameraButtonTapped() {
        presentImagePicker()
    }
    
    private func showDialog() {
        dialog.configure(
            title: "일기 작성을 취소하시겠어요?",
            content: "지금 나가면 작성한 내용이 모두 사라져요!",
            leftButtonTitle: "아니요",
            rightButtonTitle: "네, 취소할게요"
        )
        dialog.showAnimation()
        
        dialog.leftButton.removeTarget(nil, action: nil, for: .allEvents)
        dialog.leftButton.addAction(UIAction { [weak self] _ in
            self?.dialog.dismiss()
        }, for: .touchUpInside)
        
        dialog.rightButton.removeTarget(nil, action: nil, for: .allEvents)
        dialog.rightButton.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return .backTitle("일기 작성하기")
    }
    
    @objc public override func backButtonTapped() {
        showDialog()
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
