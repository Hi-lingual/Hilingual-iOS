//
//  DiaryWritingViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/8/25.
//

import Foundation
import Combine

import PhotosUI
import HilingualDomain

public final class DiaryWritingViewController: BaseUIViewController<DiaryWritingViewModel>, TextViewDelegate {
    
    // MARK: - Properties
    
    private let diaryWritingView = DiaryWritingView()
    private let visionKitManager = VisionKitManager()
    private let dialog = Dialog()
    private let textCountSubject = PassthroughSubject<Int, Never>()
    let selectedDate = Date()
    
    // MARK: - LifeCyccle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        visionKitManager.delegate = self
    }
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubviews(diaryWritingView, dialog)
        diaryWritingView.updateView(for: selectedDate)
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
        diaryWritingView.feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    @objc private func cameraButtonTapped() {
        presentImagePicker()
    }
    
    @objc private func feedbackButtonTapped() {
        let text = diaryWritingView.textView.text ?? ""

        let imageData: Data?
        if let image = diaryWritingView.selectedImageView.image {
            imageData = image.jpegData(compressionQuality: 0.8)
        } else {
            imageData = nil
        }

        let dateString = selectedDate.toString(format: "yyyy-MM-dd")
        print("📤 postDiary 호출")

        let entity = DiaryWritingEntity(originalText: text, date: dateString, imageFile: imageData)

        let loadingVC = self.diContainer.makeLoadingViewController()
        loadingVC.viewModel?.requestFeedback(with: entity)
        navigationController?.pushViewController(loadingVC, animated: true)
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
        
        diaryWritingView.delegate = self
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

        viewModel?.$successDiaryId
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.notifyLoadingVC(.success(()))
            }
            .store(in: &cancellables)

        viewModel?.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.notifyLoadingVC(.failure(error))
            }
            .store(in: &cancellables)
    }

    private func notifyLoadingVC(_ result: Result<Void, Error>) {
        guard let loadingVC = navigationController?.viewControllers.last(where: { $0 is LoadingViewController }) as? LoadingViewController else {
            return
        }
        loadingVC.viewModel?.feedbackCompletedSubject.send(result)
    }
    
    func textView(_ textView: TextView, didChangeTextCount count: Int) {
        textCountSubject.send(count)
    }
}

// MARK: - PHPickerViewControllerDelegate + 이미지 선택기

extension DiaryWritingViewController: PHPickerViewControllerDelegate {
    
    /// 이미지 선택기 띄우기 (OCR용 / 일반용 구분)
    func presentImagePicker(isForOCR: Bool = false) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        if isForOCR {
            picker.view.tag = 999 // OCR 식별 태그
        }
        
        present(picker, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("❌ 이미지 선택 실패 or 불러오기 불가")
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let error = error {
                print("❌ 이미지 로드 에러: \(error.localizedDescription)")
                return
            }
            guard let self = self, let image = image as? UIImage else {
                print("❌ 이미지 변환 실패")
                return
            }
            
            DispatchQueue.main.async {
                print("✅ 이미지 선택 완료 - OCR용?: \(picker.view.tag == 999)")
                if picker.view.tag == 999 {
                    self.visionKitManager.handleOCRImage(image)
                } else {
                    self.diaryWritingView.setImage(image)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate + 카메라 촬영기

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

// MARK: - DiaryWritingViewDelegate (카메라/갤러리 버튼 터치 이벤트)

@MainActor
extension DiaryWritingViewController: DiaryWritingViewDelegate {
    func didTapCamera() {
        presentCamera()
        self.diaryWritingView.modal.isHidden = true
    }

    func didTapGallery() {
        presentImagePicker(isForOCR: false) // 일반 이미지 선택기
        self.diaryWritingView.modal.isHidden = true
    }

    func didTapOCRGallery() {
        presentImagePicker(isForOCR: true)  // OCR용 이미지 선택기
        self.diaryWritingView.modal.isHidden = true
    }
}

extension DiaryWritingViewController: VisionKitManagerDelegate {
    func didRecognizeText(_ text: String) {
        let limitedText = String(text.prefix(diaryWritingView.textView.maxCharacterCount))
        diaryWritingView.setText(limitedText)
    }
}

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
