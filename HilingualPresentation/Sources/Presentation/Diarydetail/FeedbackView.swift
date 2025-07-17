//
//  FeedbackView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import UIKit
import SnapKit

final class FeedbackView: BaseUIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let detailImageView = DetailImageView(image: UIImage(resource: .imgLoadFailLargeIos))
    
    private var currentDiaryData: DiaryViewData?
    private var isHighlightingEnabled: Bool = true
    private let toggleButton = UIButton(type: .system)
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_14)
        label.textColor = .gray700
        return label
    }()
    
    let AILabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_m_12)
        label.textColor = .gray700
        label.text = "AI가 쓴 일기"
        return label
    }()
    
    lazy var controlSwitch: CompactSwitch = {
        let toggle = CompactSwitch()
        toggle.onTintColor = .hilingualOrange
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(toggleButtonTapped), for: .valueChanged)
        toggle.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        return toggle
    }()
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let diaryTextView: HighlightTextView = HighlightTextView()
    
    private let feedbackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let feedbackLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_16)
        label.textColor = .hilingualBlack
        return label
    }()
    
    private let emptyFeedbackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "img_feedback_wow_ios", in: .module, with: nil))
        imageView.contentMode = .scaleAspectFit
        
        let separator = UIView()
        separator.backgroundColor = .gray300
        
        let label = UILabel()
        label.text = "완벽한 일기네요. 틀린 부분 하나 없이 잘 썼어요!"
        label.font = .suit(.body_m_14)
        label.textColor = .hilingualBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [imageView, separator, label])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        
        view.addSubview(stack)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.snp.makeConstraints {
            $0.height.equalTo(199)
        }
        
        stack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        separator.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        return view
    }()
    
    // MARK: - Custom Method
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.addArrangedSubviews(headerStackView, diaryTextView, feedbackStackView)
        headerStackView.addArrangedSubviews(dateLabel, AILabel, controlSwitch)
        feedbackStackView.addArrangedSubview(feedbackLabel)
        
        backgroundColor = .gray100
        isHighlightingEnabled.toggle()
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.setCustomSpacing(12, after: headerStackView)
        
        controlSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        diaryTextView.snp.makeConstraints {
//            $0.top.equalTo(headerStackView.snp.bottom).offset(120)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        feedbackStackView.snp.makeConstraints {
            $0.top.equalTo(diaryTextView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        feedbackLabel.snp.makeConstraints {
            $0.top.equalTo(diaryTextView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Configure
    
    func configureDiary(data: DiaryViewData) {
        currentDiaryData = data
        dateLabel.text = data.date
        diaryTextView.configure(
            image: data.imageURL,
            originalText: data.originalText,
            highlightText: data.rewriteText,
            diffRanges: data.diffRanges,
            isHighlightingEnabled: data.isHighlightingEnabled
        )
    }
    
    func configureFeedbacks(data: [FeedbackItem]) {
        feedbackStackView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }
        
        if data.isEmpty {
            feedbackLabel.text = "일기에서 발견된 피드백이 없어요!"
            feedbackStackView.addArrangedSubview(emptyFeedbackView)
            emptyFeedbackView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
            return
        }
        
        let count = data.count
        let fullText = "주요 피드백 \(count)개를 알려드릴게요!"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: "\(count)") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: UIColor.hilingualOrange, range: nsRange)
        }
        
        feedbackLabel.attributedText = attributedText
        
        data.forEach {
            let feedbackView = HighlightingFeedback()
            feedbackView.configure(
                original: $0.original,
                rewrite: $0.rewrite,
                explanation: $0.explanation
            )
            feedbackStackView.addArrangedSubview(feedbackView)
            feedbackView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        let bottomSpacingView = UIView()
        feedbackStackView.addArrangedSubview(bottomSpacingView)
        bottomSpacingView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - Actions
    
    @objc private func toggleButtonTapped() {
        guard var data = currentDiaryData else { return }
        
        data = DiaryViewData(
            imageURL: data.imageURL,
            date: data.date,
            originalText: data.originalText,
            rewriteText: data.rewriteText,
            diffRanges: data.diffRanges,
            isHighlightingEnabled: !data.isHighlightingEnabled
        )
        
        configureDiary(data: data)
        currentDiaryData = data
    }
}

final class CompactSwitch: UISwitch {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = self.bounds.insetBy(dx: 10, dy: 10)
        return bounds.contains(point)
    }
}
