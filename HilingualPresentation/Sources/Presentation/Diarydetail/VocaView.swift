//
//  VocaView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import UIKit
import SnapKit

final class VocaView: BaseUIView {
    
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
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

    func configure(with cards: [(PhraseData, WordCardType)]) {
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() } 
        
        cards.forEach { data, type in
            let card = WordCard()
            card.configure(type: type, data: data)
            card.onBookmarkToggled = { isBookmarked in
                print(" \(data.phrase) 북마크 상태: \(isBookmarked)")
            }
            contentView.addArrangedSubview(card)
        }
    }
}
