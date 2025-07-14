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
    
    func configure(data: [PhraseData.PhraseList]){
        let dataList = data
        
        dataList.forEach { phrase in
            let wordCard = WordCard()
            wordCard.configure(type: .withExample, data: phrase)
            wordCard.onBookmarkToggled = { isBookmarked in
                print(" \(phrase) 북마크 상태: \(isBookmarked)")
            }
            contentView.addArrangedSubview(wordCard)
        }
    }
}
