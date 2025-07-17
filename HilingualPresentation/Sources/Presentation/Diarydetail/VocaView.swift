//
//  VocaView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import UIKit
import SnapKit

struct PhraseViewData {
    let phraseId: Int64
    let phraseType: [String]
    let phrase: String
    let explanation: String
    let reason: String
    let isMarked: Bool
    let createdAt: String // 빈값 허용
}

final class VocaView: BaseUIView {
    
    var onBookmarkToggle: ((Int64, Bool) -> Void)?

    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    let bottomSpacingView = UIView()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_14)
        label.textColor = .gray700
        return label
    }()
    
    // MARK: - Custom Method
    
    override func setUI() {
        self.backgroundColor = .gray100
        contentView.axis = .vertical
        contentView.spacing = 12
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addArrangedSubviews(dateLabel,bottomSpacingView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-16)

        }

        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
        }

        bottomSpacingView.snp.makeConstraints {
            $0.height.equalTo(16)
        }
    }
    
    // MARK: - Configure
    
    func configure(dataList: [PhraseViewData]) {
        contentView.arrangedSubviews
            .filter { $0 !== dateLabel && $0 !== bottomSpacingView }
            .forEach { $0.removeFromSuperview() }
        
        dataList.forEach { phrase in
            let wordCard = WordCard()
            wordCard.configure(
                type: .withExample,
                data: PhraseData(
                    phraseId: phrase.phraseId,
                    phraseType: phrase.phraseType,
                    phrase: phrase.phrase,
                    explanation: phrase.explanation,
                    reason: phrase.reason,
                    createdAt: phrase.createdAt,
                    isMarked: phrase.isMarked
                )
            )
            wordCard.onBookmarkToggled = { isBookmarked in
                self.onBookmarkToggle?(phrase.phraseId, isBookmarked)
            }
            contentView.insertArrangedSubview(wordCard, at: contentView.arrangedSubviews.count - 1) // bottomSpacingView 위에 삽입
        }
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func setDate(_ date: String) {
        self.dateLabel.text = date
    }
}
