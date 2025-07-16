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
    
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    // MARK: - Custom Method
    
    override func setUI() {
        self.backgroundColor = .systemGray6
        contentView.axis = .vertical
        contentView.spacing = 20
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.width.equalToSuperview().offset(-40)
        }
    }
    
    // MARK: - Configure
    
    func configure(dataList: [PhraseViewData]) {
        // 기존 뷰 제거
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새 데이터로 구성
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
                print("\(phrase.phrase) 북마크 상태: \(isBookmarked)")
            }

            contentView.addArrangedSubview(wordCard)
        }
    }
}
