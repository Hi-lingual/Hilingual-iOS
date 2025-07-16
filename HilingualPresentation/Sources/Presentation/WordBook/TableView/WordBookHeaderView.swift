//
//  WordBookHeaderView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import UIKit
import SnapKit

final class WordBookHeaderView: UITableViewHeaderFooterView {

    static let identifier = "WordNoteSectionHeaderView"

    private let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        titleLabel.font = .suit(.body_sb_16)
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(8)
            $0.top.equalToSuperview().offset(12)  
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title.uppercased()
    }
}
