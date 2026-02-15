//
//  WordBookStudyView.swift
//  HilingualPresentation
//
//  Created by Codex on 2/15/26.
//

import UIKit
import SnapKit

final class WordBookStudyView: BaseUIView {

    private let gradientLayer = CAGradientLayer()

    // MARK: - UI

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_arrow_left_b_24_ios", in: .module, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    let remainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendard(.head_sb_18)
        label.textAlignment = .center
        return label
    }()

    let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    let notRememberedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("안 외움", for: .normal)
        button.setTitleColor(.gray850, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.body_sb_14)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray300.cgColor
        button.layer.cornerRadius = 26
        return button
    }()

    let rememberedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("외움", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.body_sb_14)
        button.backgroundColor = UIColor(red: 0.20, green: 0.72, blue: 0.41, alpha: 1)
        button.layer.cornerRadius = 26
        return button
    }()

    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notRememberedButton, rememberedButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "학습이 완료됐어요"
        label.textColor = .white
        label.font = UIFont.pretendard(.body_r_14)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .clear

        gradientLayer.colors = [
            UIColor(red: 0.37, green: 0.12, blue: 0.43, alpha: 1).cgColor,
            UIColor(red: 0.22, green: 0.07, blue: 0.30, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        addSubviews(backButton, remainingLabel, cardContainerView, actionStackView, emptyLabel)
    }

    override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(28)
        }

        remainingLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.centerX.equalToSuperview()
        }

        cardContainerView.snp.makeConstraints {
            $0.top.equalTo(remainingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(actionStackView.snp.top).offset(-12)
        }

        actionStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(52)
        }

        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func updateRemainingCount(_ count: Int) {
        remainingLabel.text = "\(count)개 남음"
    }
}
