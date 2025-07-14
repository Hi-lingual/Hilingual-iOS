//
//  EmptyDiaryView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/11/25.
//

import UIKit
import SnapKit

final class EmptyDiaryView: UIView {

    private let emptyDiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 일기가 없어요.\n좋은 하루 보내셨기를 바라요!"
        label.font = .suit(.body_sb_14)
        label.textColor = .gray400
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let emptyDiaryView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_diary_empty_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    private let emptyDiaryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(emptyDiaryStack)
        emptyDiaryStack.addArrangedSubviews(
            emptyDiaryView,
            emptyDiaryLabel
        )
    }

    private func setupLayout() {
        emptyDiaryStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
