//
//  WordBookStudyView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/15/26.
//

import UIKit
import SnapKit
import Lottie

final class WordBookStudyView: BaseUIView {

    private let gradientLayer = CAGradientLayer()

    // MARK: - UI

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_arrow_left_b_24_ios", in: .module, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    let remainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        button.setTitle("모르겠어요", for: .normal)
        button.setTitleColor(.gray850, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.body_m_16)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    let rememberedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("알아요", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.body_m_16)
       button.backgroundColor = .hilingualBlack
        button.layer.cornerRadius = 8
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

    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.body_m_16)
        button.backgroundColor = .hilingualBlack
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_login_ios_v2", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let emptyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "단어를 모두 확인했어요.\n 다른 단어도 보러 가볼까요?"
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.pretendard(.head_sb_20)
        label.textAlignment = .center
        return label
    }()

    lazy var emptyContainerView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyImageView, emptyTextLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.isHidden = true
        return stack
    }()

    // For backward compatibility
    var emptyLabel: UIStackView {
        return emptyContainerView
    }

    // MARK: - Setup

    override func setUI() {
       backgroundColor = .gray200

        addSubviews(backButton, remainingLabel, cardContainerView, actionStackView, completeButton, emptyContainerView)
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

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(52)
        }

        emptyContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(180)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func updateRemainingCount(_ count: Int) {
        remainingLabel.text = "\(count)개 남음"
    }

    func showCompleteState() {
        completeButton.isHidden = false
        completeButton.alpha = 0

        emptyContainerView.isHidden = false
        emptyContainerView.alpha = 0

        UIView.animate(withDuration: 0.3) {
            self.actionStackView.alpha = 0
            self.completeButton.alpha = 1
            self.emptyContainerView.alpha = 1
        } completion: { _ in
            self.actionStackView.isHidden = true
        }
    }
}
