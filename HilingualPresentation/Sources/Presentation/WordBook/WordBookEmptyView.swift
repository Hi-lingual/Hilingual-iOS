//
//  WordBookEmptyView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/16/25.
//

import UIKit
import SnapKit

final class WordBookEmptyView: UIView {

    // MARK: - UI Components

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_word_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 단어가 추가되지 않았어요."
        label.font = .suit(.head_m_18)
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()

    public let emptyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("일기 쓰고 단어 추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .suit(.body_m_16)
        button.backgroundColor = .hilingualBlack
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyImageView, emptyLabel, emptyButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0 
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        addSubview(stackView)
        stackView.setCustomSpacing(8, after: emptyImageView)
        stackView.setCustomSpacing(16, after: emptyLabel)
    }

    private func setupLayout() {
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        emptyButton.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.width.equalTo(175)
        }
    }
}
