//
//  DiaryWritingView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/8/25.
//

import UIKit
import SnapKit

final class DiaryWritingView: BaseUIView {
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "6월 20일 금요일"
        label.font = .suit(.body_sb_16)
        label.textAlignment = .center
        label.textColor = .gray850
        return label
    }()
    
    let textScanButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        
        let attrTitle = AttributedString("텍스트 스캔하기", attributes: AttributeContainer([
            .font: UIFont.suit(.caption_r_14)
        ]))
        config.attributedTitle = attrTitle
        config.image = UIImage(resource: .icScan16Ios)
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseForegroundColor = .gray500
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
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
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(resource: .icCamera20Ios)
        config.contentInsets = NSDirectionalEdgeInsets(top: 28, leading: 28, bottom: 28, trailing: 28)
        
        button.configuration = config
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.backgroundColor = .gray100
        
        return button
    }()
    
    private let feedbackButton = CTAButton(style: .TextButton("피드백 요청"), autoBackground: true)
    
    let tooltip = Tooltip("10자 이상 작성해야 피드백 요청이 가능해요!")
    
    let dropdown = Dropdown()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setTopic()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    override func setUI() {
        headerStackView.addArrangedSubviews(dateLabel, textScanButton)
        addSubviews(scrollView, feedbackButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerStackView, dropdown, textView,
            cameraButton, tooltip
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
            $0.width.equalTo(125)
            $0.height.equalTo(32)
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
            $0.bottom.equalToSuperview().inset(20)
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
    }
    
    // MARK: - Private Methods
    
    private func setTopic() {
        dropdown.topicEn = "What surprised you today?"
        dropdown.topicKor = "오늘 당신을 놀라게 한 일이 있었나요?"
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

//MARK: - Preview
@available(iOS 17.0, *)
#Preview {
    DiaryWritingView()
}
