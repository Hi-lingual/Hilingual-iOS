//
//  DiaryWritingView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/8/25.
//

import UIKit
import SnapKit
import HilingualCore

@MainActor
protocol DiaryWritingViewDelegate: AnyObject {
    func didTapCamera()
    func didTapGallery()
    func didTapOCRGallery()
    func didTapTemporarySave(text: String)
}

final class DiaryWritingView: BaseUIView {
    
    //MARK: - Properties
    
    weak var delegate: DiaryWritingViewDelegate?
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard(.body_m_16, text: "")
        label.textAlignment = .center
        label.textColor = .gray850
        return label
    }()
    
    let textScanButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        
        let attrTitle = AttributedString("텍스트 스캔하기", attributes: AttributeContainer([
            .font: UIFont.pretendard(.body_r_14)
        ]))
        config.attributedTitle = attrTitle
        config.image = UIImage(resource: .icScan16Ios)
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseForegroundColor = .gray500
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        return button
    }()
    
    let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let textView = TextView()
    
    let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(resource: .icCamera20Ios)
        config.contentInsets = NSDirectionalEdgeInsets(top: 28, leading: 28, bottom: 28, trailing: 28)
        config.baseBackgroundColor = .gray100
        
        button.configuration = config
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let deleteImageButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .gray700
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        
        button.setImage(UIImage(resource:.btClose10Ios).withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.isHidden = true
        return button
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "피드백을 요청한 일기는 수정이 불가능해요."
        label.font = .pretendard(.body_m_14)
        label.textAlignment = .center
        label.textColor = .gray400
        return label
    }()
    
    let feedbackButton = CTAButton(style: .TextButton("피드백 요청하기"), autoBackground: true)
    
    let tooltip = Tooltip("10자 이상 작성해야 피드백 요청이 가능해요!")
    
    let dropdown = Dropdown()
    
    lazy var modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        modal.configure(
            title: "이미지 선택",
            items: [
                ("카메라로 사진 찍기", UIImage(resource: .icCamera24Ios), { [weak self] in
                    self?.delegate?.didTapCamera()
                }),
                ("갤러리에서 선택하기", UIImage(resource: .icGallary24Ios), { [weak self] in
                    self?.delegate?.didTapOCRGallery()
                })
            ]
        )
        return modal
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        addTarget()
        bindTextView()

        noticeLabel.isHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
            self.noticeLabel.isHidden = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    override func setUI() {
        headerStackView.addArrangedSubviews(dateLabel, textScanButton)
        addSubviews(scrollView, noticeLabel, feedbackButton, modal)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerStackView, dropdown, textView,
            cameraButton, tooltip,
            selectedImageView, deleteImageButton
        )
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(feedbackButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        textScanButton.snp.makeConstraints {
            $0.width.equalTo(129)
            $0.height.equalTo(33)
        }
        
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dropdown.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(dropdown.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(292)
        }
        
        cameraButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.leading.equalTo(textView)
            $0.size.equalTo(80)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        selectedImageView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.leading.equalTo(textView)
            $0.size.equalTo(80)
        }

        deleteImageButton.snp.makeConstraints {
            $0.top.equalTo(selectedImageView).offset(-7)
            $0.trailing.equalTo(selectedImageView).offset(6)
            $0.size.equalTo(18)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.bottom.equalTo(feedbackButton.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        feedbackButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tooltip.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(feedbackButton.snp.top).offset(-4)
        }
        
        modal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addTarget() {
        deleteImageButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        textScanButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    func setTopic(kor: String, en: String) {
        dropdown.configure(kor: kor, en: en)
    }
    
    func setImage(_ image: UIImage) {
        selectedImageView.image = image
        selectedImageView.isHidden = false
        deleteImageButton.isHidden = false
        cameraButton.isHidden = true
    }
        
    @objc private func deleteImage() {
        selectedImageView.image = nil
        selectedImageView.isHidden = true
        deleteImageButton.isHidden = true
        cameraButton.isHidden = false
    }
    
    @objc private func showModal() {
        modal.isHidden = false
        modal.showAnimation()
    }
    
    func setText(_ text: String) {
        textView.configure(text: text)
    }
    
    func updateView(
        for date: Date
    ) {
        setSelectedDate(date)
    }
    
    private func bindTextView() {
        textView.onTemporarySaveButtonTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.didTapTemporarySave(text: self.textView.text)
        }
    }
    
    // MARK: - Public Methods
    
    func showToast(message: String) {
        let toast = ToastMessage()
        
        self.addSubview(toast)
        toast.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(340).priority(500)
        }
        
        toast.configure(type: .basic, message: message)
    }
    
    func showBottomToast(message: String) {
        let toast = ToastMessage()
        
        self.addSubview(toast)
        
        toast.configure(type: .basic, message: message)
    }
    
    // MARK: - Binding
    
    func setSelectedDate(_ date: Date) {
        let formatter = AppTimeZone.formatter("M월 d일 EEEE")
        dateLabel.attributedText = .pretendard(.body_m_16, text: formatter.string(from: date))
    }
    
    // MARK: - Keyboard Handling
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrameInScreen = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let window = window
        else { return }

        let keyboardFrameInView = window.convert(keyboardFrameInScreen, to: self)
        let keyboardHeight = keyboardFrameInView.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight

        let textViewFrameInSelf = textView.convert(textView.bounds, to: self)
        let textViewBottomY = textViewFrameInSelf.maxY

        let keyboardTopY = self.bounds.height - keyboardHeight

        let desiredSpacing: CGFloat = 12
        let targetBottomY = keyboardTopY - desiredSpacing

        let offset = textViewBottomY - targetBottomY
        if offset > 0 {
            let newOffsetY = scrollView.contentOffset.y + offset
            scrollView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}
