//
//  WordCardCell.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import Foundation
import UIKit
import SnapKit

final class WordBookCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "WordCardCell"

    // MARK: - UI

    private let wordCard = WordCard()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(wordCard)
    }

    private func setupLayout() {
        wordCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configure

    func configure(with data: PhraseData, type: WordCardType = .basic) {
        wordCard.configure(type: type, data: data)

        wordCard.onBookmarkToggled = { [weak self] isMarked in
            self?.onBookmarkToggled?(isMarked)
        }
    }

    // MARK: - Event
    
    var onBookmarkToggled: ((Bool) -> Void)?
}
