//
//  BlockModal.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/26/25.
//

import UIKit
import SnapKit

final class BlockModal: UIView {
    
    // MARK: - Callback
    var onApplyTapped: (() -> Void)?
    
    // MARK: - Properties
    private let backgroundDimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dim
        view.alpha = 0
        return view
    }()

    private let modalSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_18)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "정말 차단하실 건가요?"
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_14)
        label.textColor = .gray400
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "차단 시 상대방은 차단 여부를 알 수 없으며,\n언제든 차단을 해제 할 수 있어요."
        return label
    }()
    
    private let blockedUserStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let blockedByMeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let blockedUserIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_check_20_ios", in: .module, with: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let blockedByMeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_check_20_ios", in: .module, with: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let blockedUserInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_14)
        label.textColor = .gray850
        label.text = "상대의 모든 활동을 확인할 수 없어요."
        return label
    }()
    
    private let blockedByMeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_14)
        label.textColor = .gray850
        label.text = "상대는 나의 모든 활동을 확인할 수 없어요."
        return label
    }()

    private let applyButton = CTAButton(style: .TextButton("차단하기"), autoBackground: false)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        addSubviews(backgroundDimView, modalSheetView)
        
        blockedUserStack.addArrangedSubviews(blockedUserIcon, blockedUserInfoLabel)
        blockedByMeStack.addArrangedSubviews(blockedByMeIcon, blockedByMeInfoLabel)

        modalSheetView.addSubviews(titleLabel, infoLabel, blockedUserStack, blockedByMeStack, applyButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundDimView.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        backgroundDimView.snp.makeConstraints { $0.edges.equalToSuperview() }

        modalSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        blockedUserStack.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
        }
        
        blockedByMeStack.snp.makeConstraints {
            $0.top.equalTo(blockedUserStack.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }

        applyButton.snp.makeConstraints {
            $0.top.equalTo(blockedByMeStack.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(58)
        }
    }

    private func setupAction() {
        applyButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onApplyTapped?()
            self.dismiss()
        }, for: .touchUpInside)
    }

    // MARK: - Animation
    public func show(in parentView: UIView) {
        self.removeFromSuperview()
        
        parentView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }

        layoutIfNeeded()
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: modalSheetView.frame.height)
        self.backgroundColor = .clear

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.dim
        }
    }

    @objc public func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: self.modalSheetView.frame.height)
            self.backgroundColor = UIColor.dim.withAlphaComponent(0)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
