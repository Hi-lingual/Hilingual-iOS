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
    
    private(set) var diaryWritingView = DiaryWritingView()
    private(set) var visionKitManager = VisionKitManager()
    private let dialog = Dialog()
    private let textCountSubject = PassthroughSubject<Int, Never>()
    private let topicData: (String, String)?
    private let selectedDate: Date
    var currentPickerMode: PickerMode?
    
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
    
    func showErrorDialog() {
        dialog.configure(
            style: .error,
            image: UIImage(resource: .imgErrorIos),
            title: "앗! 일시적인 오류가 발생했어요.",
            rightButtonTitle: "확인",
            rightAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        
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
            style: .normal,
            title: "일기 작성을 취소하시겠어요?",
            content: "지금 나가면 작성한 내용이 모두 사라져요!",
            leftButtonTitle: "아니요",
            rightButtonTitle: "취소하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        
        dialog.showAnimation()
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
        
        viewModel?.successDiaryId
            .sink { [weak self] _ in
                self?.notifyLoadingVC(.success(()))
            }
            .store(in: &cancellables)
        
        viewModel?.error
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
