//
//  LikeCounterView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/13/25.
//

import UIKit
import SnapKit

final class LikeCounterView: UIView {

    enum Style {
        case horizontal
        case vertical
    }

    // MARK: - Public State

    private(set) var isLiked: Bool = false {
        didSet {
            updateIcon()
        }
    }

    private(set) var likeCount: Int = 0 {
        didSet {
            updateCount()
        }
    }

    var onToggle: ((Bool) -> Void)?

    // MARK: - UI

    private let likeButton = UIButton(type: .custom)
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray850
        label.textAlignment = .left
        return label
    }()

    private let style: Style

    // MARK: - Init

    init(style: Style = .horizontal) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        self.style = .horizontal
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubviews(likeButton, countLabel)

        likeButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)

        updateIcon()
        updateCount()
        applyLayout()
    }

    private func applyLayout() {
        likeButton.snp.removeConstraints()
        countLabel.snp.removeConstraints()

        switch style {
        case .horizontal:
            countLabel.font = .suit(.body_sb_14)

            likeButton.snp.makeConstraints {
                $0.top.bottom.leading.equalToSuperview()
                $0.size.equalTo(24)
            }
            countLabel.snp.makeConstraints {
                $0.leading.equalTo(likeButton.snp.trailing).offset(4)
                $0.trailing.equalToSuperview()
                $0.centerY.equalTo(likeButton)
            }

        case .vertical:
            countLabel.font = .suit(.caption_m_12)

            likeButton.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.size.equalTo(24)
            }
            countLabel.snp.makeConstraints {
                $0.top.equalTo(likeButton.snp.bottom).offset(3)
                $0.bottom.equalToSuperview()
                $0.centerX.equalTo(likeButton)
            }
        }
    }

    private func updateIcon() {
        let imageName = isLiked ? "ic_like_24_ios" : "ic_unlike_24_ios"
        likeButton.setImage(UIImage(named: imageName, in: .module, with: nil), for: .normal)
    }

    private func updateCount() {
        countLabel.text = "\(likeCount)"
    }

    // MARK: - Actions

    @objc private func didTap() {
        isLiked.toggle()
        animateHeartPop()

        let newCount = max(0, likeCount + (isLiked ? 1 : -1))
        animateCountFlip(to: newCount)
        likeCount = newCount

        onToggle?(isLiked)
    }

    func configure(likeCount: Int, isLiked: Bool) {
        self.likeCount = max(0, likeCount)
        self.isLiked = isLiked
    }

    // MARK: - Animations

    private func animateHeartPop() {
        likeButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 1.2,
            options: .curveEaseOut,
            animations: {
                self.likeButton.transform = .identity
            },
            completion: nil
        )
    }

    private func animateCountFlip(to newValue: Int) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromTop, .curveEaseOut]

        UIView.transition(
            with: countLabel,
            duration: 0.25,
            options: transitionOptions,
            animations: {
                self.countLabel.text = "\(newValue)"
                self.countLabel.transform = CGAffineTransform(translationX: 0, y: -4)
            }, completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.countLabel.transform = .identity
                }
            }
        )
    }
}
