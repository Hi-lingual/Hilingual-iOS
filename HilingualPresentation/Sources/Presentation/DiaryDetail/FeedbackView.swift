//
//  FeedbackView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import UIKit
import SnapKit

final class FeedbackView: BaseUIView {

    // MARK: - Properties

    var onToggleChanged: ((Bool) -> Void)?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let bottomSpacingView = UIView()
    private let detailImageView = DetailImageView(image: UIImage(resource: .imgLoadFailLargeIos))

    private var currentDiaryData: DiaryViewData?
    private var isHighlightingEnabled: Bool = true
    private let toggleButton = UIButton(type: .system)

    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_16)
        label.textColor = .gray700
        return label
    }()

    let AILabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray500
        label.text = "교정된 일기"
        return label
    }()
    
    let dropdown = Dropdown(style: .selectedDate)
    
    lazy var controlSwitch: CustomToggle = {
        let toggle = CustomToggle(frame: CGRect(x: 0, y: 0, width: 52, height: 28))
        toggle.addTarget(self, action: #selector(toggleButtonTapped), for: .valueChanged)
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
        label.font = .pretendard(.body_m_16)
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
        label.text = "추가 설명이 필요 없는 일기네요!"
        label.font = .pretendard(.body_r_14)
        label.textColor = .hilingualBlack
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
            $0.edges.equalToSuperview().inset(12)
        }

        separator.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(separator.snp.bottom).offset(8)
        }

        return view
    }()

    // MARK: - Custom Method

    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.addArrangedSubviews(headerStackView, dropdown, diaryTextView, feedbackStackView, bottomSpacingView)
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
        contentView.setCustomSpacing(12, after: dropdown)
        headerStackView.setCustomSpacing(4, after: AILabel)

        controlSwitch.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.width.equalTo(52)
        }

        contentView.layoutMargins = UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
        contentView.isLayoutMarginsRelativeArrangement = true

        dropdown.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        diaryTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        feedbackStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        feedbackLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        bottomSpacingView.snp.makeConstraints {
            $0.height.equalTo(30)
        }

        contentView.setCustomSpacing(40, after: diaryTextView)
    }

    func scrollToTop() {
        scrollView.setContentOffset(.zero, animated: true)
    }

    // MARK: - Ad

    private var adBannerView: UIView?

    func setAdBannerView(_ adView: UIView) {
        adBannerView?.removeFromSuperview()
        adBannerView = adView
        
        let index = contentView.arrangedSubviews.firstIndex(of: bottomSpacingView)
                    ?? contentView.arrangedSubviews.count
        contentView.insertArrangedSubview(adView, at: index)
        
        adView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }

    func removeAdBannerView() {
        adBannerView?.removeFromSuperview()
        adBannerView = nil
    }

    // MARK: - Configure

    func setTopic(kor: String, en: String) {
        dropdown.configure(kor: kor, en: en)
    }

    func configureDiary(data: DiaryViewData) {
        currentDiaryData = data
        dateLabel.attributedText = .pretendard(.body_m_16, text: data.date)

        diaryTextView.configure(
            image: data.imageURL,
            originalText: data.originalText,
            highlightText: data.rewriteText,
            diffRanges: data.diffRanges,
            isHighlightingEnabled: data.isHighlightingEnabled,
        )
    }

    func configureFeedbacks(data: [FeedbackItem]) {
        feedbackStackView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }

        if data.isEmpty {
            feedbackLabel.font = .pretendard(.body_m_16)
            feedbackLabel.attributedText = .pretendard(.body_m_16, text: "일기에서 발견된 피드백이 없어요!")
            feedbackStackView.addArrangedSubview(emptyFeedbackView)
            emptyFeedbackView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
            
            let bottomSpacingView = UIView()
            feedbackStackView.addArrangedSubview(bottomSpacingView)
            bottomSpacingView.snp.makeConstraints {
                $0.height.equalTo(24)
            }
            return
        }

        let count = data.count
        let fullText = "주요 피드백 \(count)개를 알려드릴게요!"
        let attributedText = NSMutableAttributedString(
            attributedString: .pretendard(.body_m_16, text: fullText)
        )

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
            $0.height.equalTo(30)
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
            isHighlightingEnabled: !data.isHighlightingEnabled,
            isPublished: data.isPublished
        )

        configureDiary(data: data)
        currentDiaryData = data

        onToggleChanged?(data.isHighlightingEnabled)
    }
}
