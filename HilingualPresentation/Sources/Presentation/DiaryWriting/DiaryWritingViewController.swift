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
    
    //MARK: - PickerMode
    
    enum PickerMode {
        case normal
        case ocr
    }
    
    // MARK: - Properties
    
    private let diaryWritingView = DiaryWritingView()
    private let visionKitManager = VisionKitManager()
    private let dialog = Dialog()
    private let textCountSubject = PassthroughSubject<Int, Never>()
    private let topicData: (String, String)?
    private let selectedDate: Date
    private var currentPickerMode: PickerMode?
    
    // MARK: - LifeCyccle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        visionKitManager.delegate = self
    }
    
    // MARK: - Init

    public init(
        viewModel: DiaryWritingViewModel,
        diContainer: any ViewControllerFactory,
        topicData: (String, String)?,
        selectedDate: Date
    ) {
        self.topicData = topicData
        self.selectedDate = selectedDate
        super.init(viewModel: viewModel, diContainer: diContainer)
    }
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubviews(diaryWritingView, dialog)
        diaryWritingView.updateView(for: selectedDate)
        
        if let topic = topicData {
            diaryWritingView.setTopic(kor: topic.0, en: topic.1)
        }
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
    
    func showErrorDialog(title: String = "이미지 에러 발생", message: String) {
        dialog.configure(
            title: title,
            content: message,
            leftButtonTitle: "확인",
            rightButtonTitle: "닫기"
        )
        
        dialog.rightButton.removeTarget(nil, action: nil, for: .allEvents)
        dialog.rightButton.addAction(UIAction { [weak self] _ in
            self?.dialog.dismiss()
        }, for: .touchUpInside)
        
        dialog.leftButton.removeTarget(nil, action: nil, for: .allEvents)
        dialog.leftButton.addAction(UIAction { _ in
            self.dialog.dismiss()
        }, for: .touchUpInside)
        dialog.showAnimation()
    }
    
    @objc private func cameraButtonTapped() {
        presentImagePicker()
    }
    
    @objc private func feedbackButtonTapped() {
        let text = diaryWritingView.textView.text

        let imageData: Data?
        if let image = diaryWritingView.selectedImageView.image {
            imageData = image.jpegData(compressionQuality: 0.8)
        } else {
            imageData = nil
        }

        let dateString = selectedDate.toFormattedString("yyyy-MM-dd")
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
        presentImagePicker(mode: .normal) // 일반 이미지 선택기
        self.diaryWritingView.modal.isHidden = true
    }

    func didTapOCRGallery() {
        presentImagePicker(mode: .ocr)  // OCR용 이미지 선택기
        self.diaryWritingView.modal.isHidden = true
    }
}

extension DiaryWritingViewController: VisionKitManagerDelegate {
    func didRecognizeText(_ text: String) {
        let limitedText = String(text.prefix(diaryWritingView.textView.maxCharacterCount))
        diaryWritingView.setText(limitedText)
    }
    
    func didFailWithError(_ message: String) {
        showErrorDialog(title: "텍스트 스캔 에러 발생", message: message)
    }
}

