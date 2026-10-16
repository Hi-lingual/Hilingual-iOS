//
//  MilestonePopupView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 10/16/26.
//

import UIKit
import SnapKit

final class MilestonePopupView: BaseUIView {

    // MARK: - Properties

    var onClose: (() -> Void)?
    var onShareTapped: ((UIImage) -> Void)?
    var onSaveTapped: ((UIImage) -> Void)?

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let cardView = MilestoneCardView()

    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .btnCloseCircle), for: .normal)
        return button
    }()

    private let shareButton = MilestoneActionButton(icon: .icExport24Ios, title: "공유")
    private let saveButton = MilestoneActionButton(icon: .icDownload24Ios, title: "저장")

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 24
        return stack
    }()

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .dim2
        alpha = 0

        addSubview(containerView)
        containerView.addSubviews(cardView, buttonStackView, closeButton)
        buttonStackView.addArrangedSubviews(shareButton, saveButton)

        addTarget()
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(32)
        }

        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(22)
        }
    }

    private func addTarget() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    // MARK: - Configure

    func configure(count: Int) {
        cardView.configure(count: count)
    }

    func show(on window: UIWindow) {
        window.addSubview(self)
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    // MARK: - Action

    @objc private func closeTapped() {
        dismiss()
        onClose?()
    }

    @objc private func shareTapped() {
        containerView.layoutIfNeeded()
        onShareTapped?(cardView.renderImage())
    }

    @objc private func saveTapped() {
        containerView.layoutIfNeeded()
        onSaveTapped?(cardView.renderImage())
    }
}
