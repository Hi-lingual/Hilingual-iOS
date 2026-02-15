//
//  WordStudyCard.swift
//  HilingualPresentation
//
//  Created by Codex on 2/15/26.
//

import UIKit
import SnapKit

private enum SwipeDirection {
    case left
    case right
}

@MainActor
protocol WordStudyCardDelegate: AnyObject {
    func cardDidSwipeLeft(_ card: WordStudyCard)
    func cardDidSwipeRight(_ card: WordStudyCard)
}

final class WordStudyCard: UIView {

    private let thresholdRatio: CGFloat = 0.25
    private let velocityThreshold: CGFloat = 700
    private let rotationStrength: CGFloat = 0.004
    private let overlayMaxAlpha: CGFloat = 0.7

    weak var delegate: WordStudyCardDelegate?

    private let word: PhraseData
    private let contentView = WordCard()
    private let overlayView = UIView()
    private let overlayIconContainer = UIView()
    private let overlayIconView = UIImageView()
    private let overlayLabel = UILabel()
    private var originalCenter = CGPoint.zero

    init(word: PhraseData) {
        self.word = word
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        configure()
        addGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        overlayView.backgroundColor = .clear
        overlayView.alpha = 0
        overlayView.isUserInteractionEnabled = false

        overlayIconContainer.backgroundColor = .white
        overlayIconContainer.layer.cornerRadius = 28
        overlayIconContainer.clipsToBounds = true

        overlayIconView.tintColor = .systemBlue
        overlayIconView.contentMode = .scaleAspectFit

        overlayLabel.textColor = .white
        overlayLabel.font = .pretendard(.head_sb_20)
        overlayLabel.numberOfLines = 2
        overlayLabel.textAlignment = .left

        overlayView.addSubviews(overlayIconContainer, overlayLabel)
        overlayIconContainer.addSubview(overlayIconView)

        addSubviews(contentView, overlayView)
        contentView.isUserInteractionEnabled = false
    }

    private func setupLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        overlayIconContainer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(56)
        }

        overlayIconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(28)
        }

        overlayLabel.snp.makeConstraints {
            $0.top.equalTo(overlayIconContainer.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }

    private func configure() {
        contentView.configure(type: .withExample, data: word)
        contentView.layer.cornerRadius = 28
        contentView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.layer.cornerRadius = contentView.layer.cornerRadius
        overlayView.clipsToBounds = true
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }

    private func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }

    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }

        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)

        switch gesture.state {
        case .began:
            originalCenter = center

        case .changed:
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            let rotation = min(translation.x * rotationStrength, 0.25)
            transform = CGAffineTransform(rotationAngle: rotation)
            updateOverlay(distance: translation.x)

        case .ended, .cancelled:
            let threshold = bounds.width * thresholdRatio
            if translation.x > threshold || velocity.x > velocityThreshold {
                animateOut(direction: .right)
            } else if translation.x < -threshold || velocity.x < -velocityThreshold {
                animateOut(direction: .left)
            } else {
                resetPosition()
            }

        default:
            break
        }
    }

    private func resetPosition() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: []) {
            self.center = self.originalCenter
            self.transform = .identity
            self.overlayView.alpha = 0
        }
    }

    private func animateOut(direction: SwipeDirection) {
        guard let superview = superview else { return }

        let xOffset = direction == .right ? superview.bounds.width * 1.5 : -superview.bounds.width * 0.5
        let finishPoint = CGPoint(x: xOffset, y: center.y)
        UIView.animate(withDuration: 0.25, animations: {
            self.center = finishPoint
            self.alpha = 0
            self.overlayView.alpha = self.overlayMaxAlpha
        }, completion: { _ in
            self.removeFromSuperview()
            switch direction {
            case .left:
                self.delegate?.cardDidSwipeLeft(self)
            case .right:
                self.delegate?.cardDidSwipeRight(self)
            }
        })
    }

    func swipeLeft() {
        animateOut(direction: .left)
    }

    func swipeRight() {
        animateOut(direction: .right)
    }

    private func updateOverlay(distance: CGFloat) {
        let progress = min(abs(distance) / 140, 1)
        let alpha = overlayMaxAlpha * progress
        let isRight = distance >= 0
        let color = isRight
            ? UIColor(red: 0.20, green: 0.72, blue: 0.41, alpha: 1)
            : UIColor(red: 0.16, green: 0.50, blue: 0.82, alpha: 1)
        overlayView.backgroundColor = color
        overlayView.alpha = alpha

        if isRight {
            overlayLabel.text = "외움"
            overlayLabel.textAlignment = .left
            overlayIconContainer.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(28)
                $0.leading.equalToSuperview().inset(24)
                $0.width.height.equalTo(56)
            }
            overlayLabel.snp.remakeConstraints {
                $0.top.equalTo(overlayIconContainer.snp.bottom).offset(12)
                $0.leading.equalToSuperview().inset(24)
                $0.trailing.lessThanOrEqualToSuperview().inset(24)
            }
        } else {
            overlayLabel.text = "안 외움"
            overlayLabel.textAlignment = .right
            overlayIconContainer.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(28)
                $0.trailing.equalToSuperview().inset(24)
                $0.width.height.equalTo(56)
            }
            overlayLabel.snp.remakeConstraints {
                $0.top.equalTo(overlayIconContainer.snp.bottom).offset(12)
                $0.trailing.equalToSuperview().inset(24)
                $0.leading.greaterThanOrEqualToSuperview().inset(24)
            }
        }

        overlayIconView.image = UIImage(systemName: isRight ? "checkmark" : "eye.slash")
        overlayIconView.tintColor = color
    }
}
