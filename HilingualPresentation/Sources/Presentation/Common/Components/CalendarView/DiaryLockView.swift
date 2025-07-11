//
//  DiaryLockView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/11/25.
//

import UIKit
import SnapKit

final class DiaryLockView: UIView {

    private let diaryLockLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성 가능한 시간이 아니에요.\n오늘의 일기를 작성해주세요!"
        label.font = .suit(.body_sb_14)
        label.textColor = .gray400
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let diaryLockView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_diary_lock_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    private let diaryLockStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.backgroundColor = .white
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
        backgroundColor = .white
        addSubview(diaryLockStack)
        diaryLockStack.addArrangedSubviews(
            diaryLockView,
            diaryLockLabel
        )
    }

    private func setupLayout() {
        diaryLockStack.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.edges.equalToSuperview()
        }
    }
}

#Preview {
    DiaryLockView()
}
