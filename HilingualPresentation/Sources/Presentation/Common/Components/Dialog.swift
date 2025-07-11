//
//  Dialog.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/11/25.
//

import UIKit
import SnapKit

final class Dialog: UIView {
    
    // MARK: - UI Components
    
    private let dialogContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let dialogTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.textColor = .gray850
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let dialogContentLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_m_12)
        label.textColor = .gray400
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    public let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .suit(.body_sb_16)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    public let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .suit(.body_sb_16)
        button.backgroundColor = .hilingualOrange
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .dim
        self.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.addGestureRecognizer(tap)
    }
    
    private func setUI() {
        addSubviews(dialogContainerView)
        dialogContainerView.addSubviews(dialogTitleLabel, dialogContentLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(leftButton, rightButton)
    }
    
    private func setLayout() {
        dialogContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        dialogTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dialogContentLabel.snp.makeConstraints {
            $0.top.equalTo(dialogTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(dialogTitleLabel)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dialogContentLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        leftButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(143)
        }
        
        rightButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(143)
        }
    }
    
    // MARK: - Public Methods
    
    func showAnimation() {
        dialogContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        dialogContainerView.alpha = 0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.dialogContainerView.transform = .identity
            self.dialogContainerView.alpha = 1
        }
    }
    
    func dismiss() {
        performDismissAnimation()
    }
    
    @objc func dismiss(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: dialogContainerView)
        if !dialogContainerView.bounds.contains(location) {
            performDismissAnimation()
        }
    }
    
    // MARK: - Private Methods
    
    private func performDismissAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dialogContainerView.alpha = 0
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
            self.alpha = 1
        })
    }
}

// MARK: - Extensions

extension Dialog {
    func configure(title: String, content: String, leftButtonTitle: String, rightButtonTitle: String) {
        dialogTitleLabel.text = title
        dialogContentLabel.text = content
        leftButton.setTitle(leftButtonTitle, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
    }
}

// MARK: - Preview

#Preview {
    let dialog = Dialog()
    dialog.configure(
        title: "AI 피드백을 신고하시겠어요?",
        content: "신고된 AI 피드백은 확인 후\n서비스의 운영원칙에 따라 처리됩니다.",
        leftButtonTitle: "취소",
        rightButtonTitle: "확인"
    )
    
    dialog.isHidden = false
    return dialog
}
