//
//  WordBookStudyView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/15/26.
//

import UIKit
import SnapKit

final class WordBookStudyView: BaseUIView {

    enum State {
        case studying
        case completed
        case exitPrompt
    }

    // MARK: - Studying State

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "가볍게 탭하여 한글 뜻을 확인하세요."
        label.textColor = .gray500
        label.font = .pretendard(.body_m_15)
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
        button.setTitle("몰라요", for: .normal)
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

    // MARK: - Terminal State (Complete / ExitPrompt)

    private let terminalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let terminalTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.pretendard(.head_sb_20)
        label.textAlignment = .center
        return label
    }()

    private lazy var terminalContainerView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [terminalImageView, terminalTextLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.isHidden = true
        return stack
    }()

    let primaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.body_m_16)
        button.backgroundColor = .hilingualBlack
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .gray100

        addSubviews(
            hintLabel,
            cardContainerView,
            actionStackView,
            terminalContainerView,
            primaryButton
        )
    }

    override func setLayout() {
        cardContainerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(actionStackView.snp.top).offset(-16)
        }

        hintLabel.snp.makeConstraints {
            $0.bottom.equalTo(cardContainerView.snp.centerY).offset(-220)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        actionStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(52)
        }

        primaryButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(52)
        }

        terminalContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Public

    func hideHint() {
        guard !hintLabel.isHidden else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.hintLabel.alpha = 0
        }, completion: { _ in
            self.hintLabel.isHidden = true
        })
    }

    func setState(_ state: State) {
        switch state {
        case .studying:
            hintLabel.isHidden = false
            cardContainerView.isHidden = false
            actionStackView.isHidden = false
            terminalContainerView.isHidden = true
            primaryButton.isHidden = true

        case .completed:
            configureTerminal(
                imageName: "img_finish_study_ios",
                imageHeight: 180,
                text: "단어를 모두 복습했어요.\n노력하는 당신이 대단해요!",
                buttonTitle: "완료"
            )

        case .exitPrompt:
            configureTerminal(
                imageName: "img_onboarding_bottomsheet_4_ios",
                imageHeight: 172,
                text: "잠시만요!\n복습한 단어를 저장할까요?",
                buttonTitle: "저장하기"
            )
        }
    }

    private func configureTerminal(imageName: String, imageHeight: CGFloat, text: String, buttonTitle: String) {
        hintLabel.isHidden = true
        cardContainerView.isHidden = true
        actionStackView.isHidden = true

        let image = UIImage(named: imageName, in: .module, compatibleWith: nil)
        terminalImageView.image = image

        let aspectRatio: CGFloat = {
            guard let size = image?.size, size.height > 0 else { return 1 }
            return size.width / size.height
        }()
        terminalImageView.snp.remakeConstraints {
            $0.height.equalTo(imageHeight)
            $0.width.equalTo(terminalImageView.snp.height).multipliedBy(aspectRatio)
        }

        terminalTextLabel.text = text
        terminalContainerView.isHidden = false

        primaryButton.setTitle(buttonTitle, for: .normal)
        primaryButton.isHidden = false
    }
}
