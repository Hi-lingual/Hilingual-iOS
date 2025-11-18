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

    // MARK: - PickerMode
    enum PickerMode {
        case normal
        case ocr
    }

    // MARK: - Properties
    private(set) var diaryWritingView = DiaryWritingView()
    private(set) var visionKitManager = VisionKitManager()
    private let dialog = Dialog()
    let saveModal = Modal()
    private let textCountSubject = PassthroughSubject<Int, Never>()
    private let topicData: (String, String)?
    public let selectedDate: Date
    var currentPickerMode: PickerMode?
    let shouldLoadDraft: Bool
    var initialText: String = ""
    var imageData: Data?

    // Amplitude Tracking Properties
    private var entryId: String = UUID().uuidString
    private var writingStartTime: Date?
    private var firstInputTime: Date?
    private var dropdownClickCount: Int = 0
    private var backSource: String = "unknown"

    // MARK: - LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        visionKitManager.delegate = self
        diaryWritingView.delegate = self
        writingStartTime = Date()
        

        // 1️⃣ [Amplitude] 페이지 진입 (pageview)
        AmplitudeManager.shared.logEvent(
            "pageview",
            properties: [
                "entry_id": entryId,
                "back_source": backSource,
                "selected_date": selectedDate.toFormattedString("yyyy-MM-dd"),
                "recommen_topic": [
                    "kor": topicData?.0 ?? "",
                    "en": topicData?.1 ?? ""
                ]
            ]
        )
        
        viewModel?.loadDraftIfExists(for: selectedDate)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    public init(
        viewModel: DiaryWritingViewModel,
        diContainer: any ViewControllerFactory,
        topicData: (String, String)?,
        selectedDate: Date,
        backSource: String = "ui_button",
        shouldLoadDraft: Bool = true
    ) {
        self.topicData = topicData
        self.selectedDate = selectedDate
        self.shouldLoadDraft = shouldLoadDraft
        self.backSource = backSource
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    // MARK: - Setup
    public override func setUI() {
        saveModal.isHidden = true
        view.addSubviews(diaryWritingView, dialog, saveModal)
        diaryWritingView.updateView(for: selectedDate)

        if let topic = topicData {
            diaryWritingView.setTopic(kor: topic.0, en: topic.1)
        }
    }

    public override func setLayout() {
        diaryWritingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        saveModal.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public override func addTarget() {
        diaryWritingView.textScanButton.addTarget(self, action: #selector(textScanButtonTapped), for: .touchUpInside)
        diaryWritingView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        diaryWritingView.feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
        diaryWritingView.dropdown.addDropdownToggleAction { [weak self] in
            self?.dropdownButtonTapped()
        }
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
    
    func showDraftDialog() {
        dialog.configure(
            title: "이미 임시저장한 일기가 있어요.",
            content: "일자 당 하나의 일기만 임시저장할 수 있어요.\n임시저장한 일기에 덮어쓰시겠어요?",
            leftButtonTitle: "아니요",
            rightButtonTitle: "덮어쓰기",
            leftAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            rightAction: { [weak self] in
                self?.viewModel?.didTapTemporarySave(
                    text: self?.diaryWritingView.textView.text ?? "",
                    date: self?.selectedDate ?? Date(),
                    imageData: self?.imageData
                )
                self?.navigationController?.popViewController(animated: true)
                if let previousVC = self?.navigationController?
                    .viewControllers.dropLast().last as? HomeViewController {
                    previousVC.showToast(message: "임시저장이 완료되었어요.")
                }
                
            }
        )
        dialog.showAnimation()
    }
    
    func showDraftDialogIfBarTap() {
        dialog.configure(
            title: "이미 임시저장한 일기가 있어요.",
            content: "일자 당 하나의 일기만 임시저장할 수 있어요.\n임시저장한 일기에 덮어쓰시겠어요?",
            leftButtonTitle: "아니요",
            rightButtonTitle: "덮어쓰기",
            leftAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            rightAction: { [weak self] in
                guard let self else { return }
                let image = self.diaryWritingView.selectedImageView.image
                let imageData = image?.jpegData(compressionQuality: 0.8)
                self.dialog.dismiss()
                self.viewModel?.didTapTemporarySave(
                    text: self.diaryWritingView.textView.text,
                    date: self.selectedDate,
                    imageData: imageData
                )
                self.initialText = self.diaryWritingView.textView.text
                self.diaryWritingView.showBottomToast(message: "임시저장이 완료되었어요.")
            }
        )
        dialog.showAnimation()
    }

    // 4️⃣ [Amplitude] 텍스트 스캔하기 버튼 클릭 (click_scan_text)
    @objc private func textScanButtonTapped() {
        AmplitudeManager.shared.logEvent(
            "click_scan_text",
            properties: [
                "entry_id": entryId
            ]
        )
        diaryWritingView.modal.isHidden = false
        diaryWritingView.modal.showAnimation()
    }

    // 카메라 버튼 클릭 (이미지 추가 버튼)
    @objc private func cameraButtonTapped() {
        presentImagePicker()
    }

    // 5️⃣ [Amplitude] 드롭다운 클릭 (click_dropdown)
    private func dropdownButtonTapped() {
        dropdownClickCount += 1
        AmplitudeManager.shared.logEvent(
            "click_dropdown",
            properties: [
                "entry_id": entryId,
                "recommen_topic": [
                    "kor": topicData?.0 ?? "",
                    "en": topicData?.1 ?? ""
                ],
                "dropdown_click_count": dropdownClickCount
            ]
        )
    }

    // 7️⃣ [Amplitude] 일기 피드백 요청 (submitted_entry_diary)
    @objc private func feedbackButtonTapped() {
        let text = diaryWritingView.textView.text ?? ""
        imageData = diaryWritingView.selectedImageView.image?.jpegData(compressionQuality: 0.8)
        let dateString = selectedDate.toFormattedString("yyyy-MM-dd")

        AmplitudeManager.shared.logEvent(
            "submitted_entry_diary",
            properties: [
                "entry_id": entryId,
                "has_photo": imageData != nil,
                "char_count": text.count,
                "ai_request_start_time": Date().timeIntervalSince1970
            ]
        )

        let loadingVC = diContainer.makeLoadingViewController()
        loadingVC.viewModel?.postDiary(originalText: text, date: dateString, imageFile: imageData)
        navigationController?.pushViewController(loadingVC, animated: true)
    }

    // 2️⃣ [Amplitude] 뒤로가기 버튼 클릭 (click_back_diary)
    private func showModal() {
        diaryWritingView.endEditing(true)
        let items: [(String, UIImage, () -> Void)] = [
            ("작성취소", UIImage(resource: .icCancel24Ios), { [weak self] in
                self?.saveModal.dismissModal()
                self?.navigationController?.popViewController(animated: true)
            }),
            ("임시저장", UIImage(resource: .icSave24Ios), { [weak self] in
                if self?.shouldLoadDraft == nil {
                    self?.viewModel?.didTapTemporarySave(
                        text: self?.diaryWritingView.textView.text ?? "",
                        date: self?.selectedDate ?? Date(),
                        imageData: self?.imageData
                    )
                    self?.navigationController?.popViewController(animated: true)
                    if let previousVC = self?.navigationController?
                        .viewControllers.dropLast().last as? HomeViewController {
                        previousVC.showToast(message: "임시저장이 완료되었어요.")
                    }
                } else {
                    self?.saveModal.dismissModal()
                    self?.showDraftDialog()
                }
            })
        ]
        
        saveModal.configure(
            title: "일기 작성을 취소하시겠어요?",
            items: items
        )
        
        saveModal.isHidden = false
        saveModal.showAnimation()
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("일기 작성하기")
    }

    @objc public override func backButtonTapped() {
        // 2️⃣ 뒤로가기 버튼 클릭
        AmplitudeManager.shared.logEvent(
            "click_back_diary",
            properties: [
                "entry_id": entryId,
                "back_source": "ui_button"
            ]
        )
        
        if self.diaryWritingView.textView.text.isEmpty || self.initialText == self.diaryWritingView.textView.text {
            self.navigationController?.popViewController(animated: true)
        } else {
            showModal()
        }
    }

    // MARK: - Bind
    
    public override func bind(viewModel: DiaryWritingViewModel) {
        super.bind(viewModel: viewModel)
        diaryWritingView.delegate = self
        diaryWritingView.textView.delegate = self
        
        viewModel.draftLoaded
            .receive(on: RunLoop.main)
            .sink { [weak self] draft in
                guard let self else { return }
                guard self.shouldLoadDraft else { return }
                guard let draft else { return }
                if shouldLoadDraft {
                    self.diaryWritingView.textView.text = draft.text
                    self.initialText = diaryWritingView.textView.text
                    
                    if let data = draft.image {
                        self.diaryWritingView.selectedImageView.image = UIImage(data: data)
                    }
                }
            }
            .store(in: &cancellables)
        
        let input = DiaryWritingViewModel.Input(textCount: textCountSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        bindOutput(output)
    }

    private func bindOutput(_ output: DiaryWritingViewModel.Output) {
        output.buttonActive
            .receive(on: RunLoop.main)
            .sink { [weak self] isActive in
                self?.diaryWritingView.feedbackButton.isEnabled = isActive
                self?.diaryWritingView.tooltip.isHidden = isActive
            }
            .store(in: &cancellables)

        viewModel?.error
            .sink { [weak self] error in
                self?.notifyLoadingVC(.failure(error))
            }
            .store(in: &cancellables)
        viewModel?.didTemporarySaveComplete
            .sink { [weak self] _ in
                guard let self else { return }
            }
            .store(in: &cancellables)
    }

    private func notifyLoadingVC(_ result: Result<Void, Error>) {
        guard let loadingVC = navigationController?.viewControllers.last(where: { $0 is LoadingViewController }) as? LoadingViewController else { return }
        loadingVC.viewModel?.feedbackCompletedSubject.send(result)
    }

    // 6️⃣ [Amplitude] 텍스트 필드 활성화 (click_textfield)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstInputTime == nil {
            firstInputTime = Date()
            let timeToFirstInput = Int(firstInputTime!.timeIntervalSince(writingStartTime ?? Date()))

            AmplitudeManager.shared.logEvent(
                "click_textfield",
                properties: [
                    "entry_id": entryId,
                    "text_input_type": "typed",
                    "time_to_first_input": timeToFirstInput
                ]
            )
        }
    }

    func textView(_ textView: TextView, didChangeTextCount count: Int) {
        textCountSubject.send(count)
    }
}
