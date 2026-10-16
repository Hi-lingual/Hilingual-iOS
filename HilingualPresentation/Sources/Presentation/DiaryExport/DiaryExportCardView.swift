//
//  DiaryExportCardView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 10/16/26.
//

import UIKit
import Kingfisher
import SnapKit

final class DiaryExportCardView: BaseUIView {

    // MARK: - Properties

    private var originalText: String = ""
    private var highlightText: String = ""
    private var diffRanges: [HighlightTextView.DiffRange] = []
    private var isHighlightingEnabled: Bool = true
    private var hasImage: Bool = true
    private var isTopicVisible: Bool = true

    // MARK: - UI Components

    private let leftQuoteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_quote_L_16_ios", in: .module, with: nil))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let rightQuoteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_quote_R_16_ios", in: .module, with: nil))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let topicLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_15)
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()

    private let topicStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_12)
        label.textColor = .gray500
        return label
    }()

    private let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .imgLoadFailLargeIos)
        return imageView
    }()

    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.layoutManager.usesFontLeading = false
        textView.backgroundColor = .clear
        textView.textColor = .hilingualBlack
        return textView
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "img_logo_small_ios", in: .module, with: nil))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - setUI

    override func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true

        addSubviews(topicStackView, dividerView, dateLabel, diaryImageView, diaryTextView, logoImageView)
        topicStackView.addArrangedSubviews(leftQuoteImageView, topicLabel, rightQuoteImageView)
    }

    override func setLayout() {
        leftQuoteImageView.snp.makeConstraints { $0.size.equalTo(16) }
        rightQuoteImageView.snp.makeConstraints { $0.size.equalTo(16) }

        logoImageView.snp.makeConstraints {
            $0.top.equalTo(diaryTextView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(20)
        }

        updateCardLayout()
    }

    private func updateCardLayout() {
        topicStackView.isHidden = !isTopicVisible
        dividerView.isHidden = !isTopicVisible
        diaryImageView.isHidden = !hasImage

        if isTopicVisible {
            topicStackView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(24)
                $0.centerX.equalToSuperview()
                $0.leading.greaterThanOrEqualToSuperview().inset(16)
                $0.trailing.lessThanOrEqualToSuperview().inset(16)
            }
            dividerView.snp.remakeConstraints {
                $0.top.equalTo(topicStackView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(1)
            }
            dateLabel.snp.remakeConstraints {
                $0.top.equalTo(dividerView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        } else {
            dateLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(24)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }

        if hasImage {
            diaryImageView.snp.remakeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(diaryImageView.snp.width).multipliedBy(178.0 / 311.0)
            }
            diaryTextView.snp.remakeConstraints {
                $0.top.equalTo(diaryImageView.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        } else {
            diaryImageView.snp.remakeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(0)
            }
            diaryTextView.snp.remakeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }

    // MARK: - Configure

    func configure(
        image: String?,
        originalText: String,
        highlightText: String,
        diffRanges: [HighlightTextView.DiffRange],
        isHighlightingEnabled: Bool
    ) {
        self.originalText = originalText
        self.highlightText = highlightText
        self.diffRanges = diffRanges
        self.isHighlightingEnabled = isHighlightingEnabled

        if let image = image, !image.isEmpty, let url = URL(string: image) {
            diaryImageView.kf.setImage(with: url)
            hasImage = true
        } else {
            hasImage = false
        }

        updateCardLayout()
        applyText()
    }

    func setTopic(_ topic: String) {
        topicLabel.text = topic
    }

    func setDate(_ date: String) {
        dateLabel.attributedText = .pretendard(.body_m_12, text: date)
    }

    func setTopicVisible(_ visible: Bool) {
        guard isTopicVisible != visible else { return }
        isTopicVisible = visible
        updateCardLayout()
    }

    // MARK: - Text Highlighting

    private func applyText() {
        if isHighlightingEnabled {
            let attributedString = makeBaseAttributedText(highlightText, color: .hilingualBlack)
            applyDiffHighlights(to: attributedString, color: .hilingualOrange)
            diaryTextView.attributedText = attributedString
        } else {
            diaryTextView.attributedText = makeBaseAttributedText(originalText, color: .hilingualBlack, forceWrap: true)
        }
    }

    private func makeBaseAttributedText(_ text: String, color: UIColor, forceWrap: Bool = false) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            attributedString: .pretendard(.body_r_15, text: text, lineBreakMode: .byWordWrapping, forceWrap: forceWrap)
        )
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }

    private func applyDiffHighlights(to attributedString: NSMutableAttributedString, color: UIColor) {
        for diffRange in diffRanges {
            let range = NSRange(location: diffRange.start, length: diffRange.end - diffRange.start)
            guard range.length > 0, NSMaxRange(range) <= attributedString.length else { continue }
            attributedString.addAttributes(
                [.font: UIFont.pretendard(.body_m_15), .foregroundColor: color],
                range: range
            )
        }
    }
}
