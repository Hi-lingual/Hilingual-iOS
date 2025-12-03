//
//  WordCard.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import UIKit
import SnapKit

enum WordCardType {
    case basic
    case withExample
    case withDate
}

final class WordCard: UIView {

    // MARK: - UI Components

    private let chipStackView = UIStackView()
    private let phraseLabel = UILabel()
    private let explanationLabel = UILabel()
    private let savedDateLabel = UILabel()
    private let reasonLabel = UILabel()
    private let bookmarkButton = UIButton(type: .custom)

    // MARK: - State

    private var isMarked: Bool = false
    private var cardType: WordCardType = .basic
    var onBookmarkToggled: ((Bool) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(type: WordCardType, data: PhraseData) {
        self.cardType = type
        isMarked = data.isMarked
        
        updateBookmarkImage()
        bookmarkButton.setNeedsLayout()
        layoutIfNeeded()
        
        // Chip 초기화 및 추가
        chipStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        data.phraseType.compactMap { chipType(from: $0) }
            .map { Chip(type: $0) }
            .forEach { chipStackView.addArrangedSubview($0) }

        phraseLabel.text = data.phrase
        explanationLabel.text = data.explanation
        savedDateLabel.text = "\(data.createdAt)"
        reasonLabel.isHidden = data.reason.isEmpty
        reasonLabel.text = "\(data.reason)"
        
        explanationLabel.isHidden = false
        reasonLabel.isHidden = false
        savedDateLabel.isHidden = false
        
        switch type {
        case .basic:
            phraseLabel.font = .pretendard(.head_r_18)

            explanationLabel.isHidden = true
            reasonLabel.isHidden = true
            savedDateLabel.isHidden = true

            explanationLabel.snp.remakeConstraints {
                $0.height.equalTo(0)
            }
            reasonLabel.snp.remakeConstraints {
                $0.height.equalTo(0)
                $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-17)
            }
            savedDateLabel.snp.remakeConstraints {
                $0.height.equalTo(0)
            }
            phraseLabel.snp.remakeConstraints {
                $0.top.equalTo(chipStackView.snp.bottom).offset(4)
                $0.leading.equalToSuperview().inset(12)
                $0.trailing.equalToSuperview().inset(40)
                $0.bottom.equalToSuperview().inset(12)
            }

        case .withExample:
            phraseLabel.attributedText = .pretendard(.body_m_16, text: data.phrase)
            explanationLabel.font = .pretendard(.body_sb_14)
            reasonLabel.font = .pretendard(.cap_r_12)
            
            savedDateLabel.isHidden = true
            
            phraseLabel.snp.makeConstraints {
                $0.top.equalTo(chipStackView.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview().inset(12)
            }
            
            explanationLabel.snp.makeConstraints {
                $0.top.equalTo(phraseLabel.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview().inset(12)
            }
            
            reasonLabel.snp.makeConstraints {
                $0.top.equalTo(explanationLabel.snp.bottom).offset(8)
                $0.leading.equalToSuperview().inset(12)
                $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-17)
                $0.bottom.equalToSuperview().inset(12)
            }

        case .withDate:
            phraseLabel.font = .pretendard(.head_r_20)
            explanationLabel.font = .pretendard(.body_r_14)
            savedDateLabel.font = .pretendard(.cap_r_12)
            
            phraseLabel.numberOfLines = 2
            reasonLabel.isHidden = true
            
            chipStackView.snp.remakeConstraints {
                $0.top.leading.equalToSuperview().inset(24)
            }
            
            phraseLabel.snp.remakeConstraints {
                $0.top.equalTo(chipStackView.snp.bottom).offset(4)
                $0.leading.equalToSuperview().inset(24)
                $0.trailing.equalToSuperview().inset(68)
            }

            explanationLabel.snp.remakeConstraints {
                $0.top.equalTo(phraseLabel.snp.bottom).offset(4)
                $0.leading.equalToSuperview().inset(24)
                $0.trailing.equalToSuperview().inset(68)
            }
            
            savedDateLabel.snp.remakeConstraints {
                $0.top.equalTo(explanationLabel.snp.bottom).offset(80)
                $0.trailing.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(40)
            }
        }
        
        bookmarkButton.snp.remakeConstraints {
            let inset: CGFloat = (type == .withDate) ? 24 : 12
            let size: CGFloat = (type == .withDate) ? 36 : 28
            $0.top.trailing.equalToSuperview().inset(inset)
            $0.width.height.equalTo(size)
        }
    }

    // MARK: - Layout

    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 8

        chipStackView.axis = .horizontal
        chipStackView.spacing = 4

        explanationLabel.numberOfLines = 0
        reasonLabel.numberOfLines = 0
        reasonLabel.font = .pretendard(.cap_r_12)
        reasonLabel.textColor = .gray700

        savedDateLabel.font = .pretendard(.cap_r_12)
        savedDateLabel.textColor = .gray400

        bookmarkButton.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)

        addSubviews(chipStackView, phraseLabel, explanationLabel, savedDateLabel, reasonLabel, bookmarkButton)
    }

    private func setLayout() {
        chipStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
        }
    }

    // MARK: - Helpers

    @objc private func didTapBookmark() {
        isMarked.toggle()
        updateBookmarkImage()
        onBookmarkToggled?(isMarked)
    }

    private func updateBookmarkImage() {
        let imageName: String
        switch cardType {
        case .withDate:
            imageName = isMarked ? "ic_save_default_36_ios" : "ic_save_variant_36_ios"
        default:
            imageName = isMarked ? "ic_save_default_28_ios" : "ic_save_variant_28_ios"
        }

        let image = UIImage(named: imageName, in: .module, compatibleWith: nil)
        bookmarkButton.setImage(image, for: .normal)
    }

    private func chipType(from korTitle: String) -> ChipType? {
        switch korTitle {
        case "동사": return .verb
        case "명사": return .noun
        case "대명사": return .pronoun
        case "형용사": return .adjective
        case "부사": return .adverb
        case "전치사": return .preposition
        case "접속사": return .conjunction
        case "감탄사": return .interjection
        case "숙어": return .phrase
        case "속어": return .clause
        case "구": return .expression
        case "me": return .me
        case "AI": return .ai
        default: return nil
        }
    }
}
