//
//  WordStudyCard.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/15/26.
//

import UIKit
import SnapKit

private enum SwipeDirection {
    case left
    case right
}

private enum SwipeAxis {
    case x, y
}

@MainActor
protocol WordStudyCardDelegate: AnyObject {
    func cardDidSwipeLeft(_ card: WordStudyCard)
    func cardDidSwipeRight(_ card: WordStudyCard)
}

final class WordStudyCard: UIView {

    // Spec constants
    private let minDrag: CGFloat = 4
    private let lockAt: CGFloat = 10
    private let thresholdRatio: CGFloat = 0.25
    private let tintStartProgress: CGFloat = 0.15
    private let tintMaxAlpha: CGFloat = 0.30
    private let maxRotationDegrees: CGFloat = 12
    private let yFollow: CGFloat = 0.35
    private let velocityThreshold: CGFloat = 600
    private let snapBackDuration: TimeInterval = 0.28
    private let flyAwayDuration: TimeInterval = 0.32
    private let knowColor: UIColor = .hilingualBlue
    private let dontKnowColor: UIColor = .hilingualOrange

    weak var delegate: WordStudyCardDelegate?

    private let word: PhraseData

    // MARK: - Faces
    private let cardContentView = UIView()
    private let frontFaceView = UIView()
    private let backFaceView = UIView()
    private var isShowingBack = false
    private var isAnimatingFlip = false

    // MARK: - Front
    private let frontChipStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    private let pronunciationButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(resource: .icPlayBlack24Ios).withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    private let phraseLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_sb_20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let frontFlipHintImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_reverse_28_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Back
    private let backChipStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_sb_20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let backFlipHintImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_reverse_28_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Overlay & Stamp
    private let overlayView = UIView()
    private let stampView = StampView()
    private var originalCenter = CGPoint.zero
    private var didCrossThreshold = false
    private var axis: SwipeAxis?
    private let overlayHaptic = UIImpactFeedbackGenerator(style: .light)

    // MARK: - Pronunciation State
    private var isPronouncing: Bool = false
    private var hasPlayedPronunciation: Bool = false

    // MARK: - Callbacks
    var onPronunciationTapped: ((Bool) -> Void)?
    var onFlipped: (() -> Void)?

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

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear

        cardContentView.backgroundColor = .clear
        cardContentView.layer.cornerRadius = 28
        cardContentView.clipsToBounds = false

        frontFaceView.backgroundColor = .white
        frontFaceView.layer.cornerRadius = 28
        frontFaceView.layer.masksToBounds = true

        backFaceView.backgroundColor = .white
        backFaceView.layer.cornerRadius = 28
        backFaceView.layer.masksToBounds = true

        frontFaceView.layer.isDoubleSided = false
        backFaceView.layer.isDoubleSided = false
        backFaceView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)

        overlayView.backgroundColor = .clear
        overlayView.alpha = 0
        overlayView.isUserInteractionEnabled = false

        stampView.alpha = 0
        stampView.isUserInteractionEnabled = false

        pronunciationButton.addTarget(self, action: #selector(didTapPronunciation), for: .touchUpInside)
        pronunciationButton.isUserInteractionEnabled = true

        frontFaceView.addSubviews(frontChipStack, phraseLabel, frontFlipHintImageView)
        backFaceView.addSubviews(backChipStack, explanationLabel, backFlipHintImageView)
        cardContentView.addSubviews(frontFaceView, backFaceView)

        addSubviews(cardContentView, pronunciationButton, overlayView, stampView)

        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 900.0
        cardContentView.layer.sublayerTransform = perspective
    }

    private func setupLayout() {
        cardContentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        overlayView.snp.makeConstraints { $0.edges.equalToSuperview() }
        frontFaceView.snp.makeConstraints { $0.edges.equalToSuperview() }
        backFaceView.snp.makeConstraints { $0.edges.equalToSuperview() }

        // Front
        frontChipStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        pronunciationButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(28)
        }
        phraseLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        frontFlipHintImageView.snp.makeConstraints {
            $0.top.equalTo(phraseLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(28)
        }

        // Back
        backChipStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        explanationLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        backFlipHintImageView.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(28)
        }

        stampView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
            $0.width.equalTo(52)
        }
    }

    private func configure() {
        let chipTypes = word.phraseType.compactMap { chipType(from: $0) }
        frontChipStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        backChipStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        chipTypes.forEach { frontChipStack.addArrangedSubview(Chip(type: $0, size: .large)) }
        chipTypes.forEach { backChipStack.addArrangedSubview(Chip(type: $0, size: .large)) }

        phraseLabel.text = word.phrase
        explanationLabel.text = word.explanation

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.layer.cornerRadius = cardContentView.layer.cornerRadius
        overlayView.clipsToBounds = true
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cardContentView.layer.cornerRadius
        ).cgPath
    }

    // MARK: - Gestures

    private func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        pan.cancelsTouchesInView = false
        addGestureRecognizer(pan)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        addGestureRecognizer(tap)
    }

    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self)
        if pronunciationButton.frame.contains(point), !isShowingBack {
            return
        }
        flip()
    }

    @objc
    private func didTapPronunciation() {
        print("[WordStudyCard] didTapPronunciation - phrase: \(word.phrase), isPronouncing: \(isPronouncing)")
        let isFirstPlay = !hasPlayedPronunciation
        hasPlayedPronunciation = true
        onPronunciationTapped?(isFirstPlay)

        if isPronouncing {
            EnglishPronunciationPlayer.shared.stop()
        } else {
            EnglishPronunciationPlayer.shared.speak(word.phrase, didFinish: { [weak self] in
                self?.setPronouncing(false)
            }, didCancel: { [weak self] in
                self?.setPronouncing(false)
            })
        }
        setPronouncing(!isPronouncing)
    }

    private func setPronouncing(_ value: Bool) {
        isPronouncing = value
        let image = UIImage(resource: value ? .icPlayGray24Ios : .icPlayBlack24Ios)
            .withRenderingMode(.alwaysOriginal)
        pronunciationButton.setImage(image, for: .normal)
    }

    private func flip() {
        guard !isAnimatingFlip else { return }
        isAnimatingFlip = true
        onFlipped?()

        let showingBackNext = !isShowingBack
        let frontAngle: CGFloat = showingBackNext ? .pi : 0
        let backAngle: CGFloat = showingBackNext ? 0 : .pi

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                self.frontFaceView.layer.transform = CATransform3DMakeRotation(frontAngle, 0, 1, 0)
                self.backFaceView.layer.transform = CATransform3DMakeRotation(backAngle, 0, 1, 0)
                self.pronunciationButton.alpha = showingBackNext ? 0 : 1
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.isShowingBack.toggle()
                self.pronunciationButton.isUserInteractionEnabled = !self.isShowingBack
                self.isAnimatingFlip = false
            }
        )
    }

    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }

        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)

        switch gesture.state {
        case .began:
            originalCenter = center
            didCrossThreshold = false
            axis = nil
            overlayHaptic.prepare()

        case .changed:
            let distance = hypot(translation.x, translation.y)

            if distance < minDrag {
                center = originalCenter
                transform = .identity
                overlayView.alpha = 0
                stampView.alpha = 0
                return
            }

            if axis == nil && distance >= lockAt {
                axis = abs(translation.x) >= abs(translation.y) ? .x : .y
                if axis == .x {
                    updateStamp(isRight: translation.x >= 0)
                    stampView.alpha = 1
                }
            }

            switch axis {
            case .none:
                center = CGPoint(
                    x: originalCenter.x + translation.x,
                    y: originalCenter.y + translation.y
                )
                transform = .identity

            case .some(.x):
                let dy = translation.y * yFollow
                center = CGPoint(
                    x: originalCenter.x + translation.x,
                    y: originalCenter.y + dy
                )
                updateProgressVisuals(dx: translation.x)

            case .some(.y):
                center = originalCenter
                transform = .identity
            }

        case .ended, .cancelled:
            guard axis == .x else {
                snapBack()
                return
            }
            let threshold = bounds.width * thresholdRatio
            let progress = abs(translation.x) / threshold
            let vx = velocity.x
            if progress >= 1 || (abs(vx) > velocityThreshold && abs(translation.x) > 8) {
                animateOut(direction: translation.x >= 0 ? .right : .left)
            } else {
                snapBack()
            }

        default:
            break
        }
    }

    private func updateProgressVisuals(dx: CGFloat) {
        let threshold = bounds.width * thresholdRatio
        let progress = min(abs(dx) / threshold, 1)
        let sign: CGFloat = dx >= 0 ? 1 : -1
        let radians = progress * maxRotationDegrees * .pi / 180 * sign
        transform = CGAffineTransform(rotationAngle: radians)

        let tintProgress = max(0, (progress - tintStartProgress) / (1 - tintStartProgress))
        overlayView.backgroundColor = dx >= 0 ? knowColor : dontKnowColor
        overlayView.alpha = tintProgress * tintMaxAlpha

        updateStamp(isRight: dx >= 0)

        if progress >= 1, !didCrossThreshold {
            overlayHaptic.impactOccurred()
            didCrossThreshold = true
        }
        if progress < 1 {
            didCrossThreshold = false
        }
    }

    private func updateStamp(isRight: Bool) {
        stampView.configure(isRight: isRight, color: isRight ? knowColor : dontKnowColor)
    }

    private func snapBack() {
        let timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.2, y: 0.8),
                                             controlPoint2: CGPoint(x: 0.3, y: 1.0))
        let animator = UIViewPropertyAnimator(duration: snapBackDuration, timingParameters: timing)
        animator.addAnimations {
            self.center = self.originalCenter
            self.transform = .identity
            self.overlayView.alpha = 0
            self.stampView.alpha = 0
        }
        animator.addCompletion { [weak self] _ in
            self?.axis = nil
            self?.didCrossThreshold = false
        }
        animator.startAnimation()
    }

    private func animateOut(direction: SwipeDirection) {
        guard let superview = superview else { return }

        let xOffset = direction == .right
            ? superview.bounds.width + bounds.width
            : -(superview.bounds.width + bounds.width) / 2
        let finishPoint = CGPoint(x: xOffset, y: center.y)

        UIView.animate(withDuration: flyAwayDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.center = finishPoint
            self.alpha = 0
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
        commitFromButton(direction: .left)
    }

    func swipeRight() {
        commitFromButton(direction: .right)
    }

    private func commitFromButton(direction: SwipeDirection) {
        guard let superview = superview else { return }
        axis = .x
        let isRight = direction == .right

        overlayView.backgroundColor = isRight ? knowColor : dontKnowColor
        updateStamp(isRight: isRight)

        let xOffset = isRight
            ? superview.bounds.width + bounds.width
            : -(superview.bounds.width + bounds.width) / 2
        let finishPoint = CGPoint(x: xOffset, y: center.y)
        let rotationSign: CGFloat = isRight ? 1 : -1
        let targetRotation = maxRotationDegrees * .pi / 180 * rotationSign

        UIView.animate(withDuration: flyAwayDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform(rotationAngle: targetRotation)
            self.center = finishPoint
            self.overlayView.alpha = self.tintMaxAlpha
            self.stampView.alpha = 1
            self.alpha = 0
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

    private func isDescendant(of ancestor: UIView, view: UIView?) -> Bool {
        var candidate = view
        while let currentView = candidate {
            if currentView === ancestor { return true }
            candidate = currentView.superview
        }
        return false
    }

    private func chipType(from korTitle: String) -> ChipType? {
        switch korTitle {
        case "동사": return .verb
        case "명사": return .noun
        case "대명사": return .pronoun
        case "형용사": return .adjective
        case "부사": return .adverb
        case "전치사": return .preposition
        case "접속사": return .conjunction
        case "감탄사": return .interjection
        case "숙어": return .phrase
        case "속어": return .clause
        case "구": return .expression
        case "me": return .me
        case "AI": return .ai
        default: return nil
        }
    }
}

extension WordStudyCard: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !isDescendant(of: pronunciationButton, view: touch.view)
    }
}

private final class StampView: UIView {

    private let iconCircleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = 22
        circleView.clipsToBounds = true
        return circleView
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let captionLabel: UILabel = {
        let captionLabel = UILabel()
        captionLabel.font = .pretendard(.cap_r_12)
        captionLabel.textAlignment = .center
        return captionLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(iconCircleView, captionLabel)
        iconCircleView.addSubview(iconImageView)

        iconCircleView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(iconCircleView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(isRight: Bool, color: UIColor) {
        let symbolName = isRight ? "checkmark.circle" : "questionmark.circle"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        iconImageView.image = UIImage(systemName: symbolName, withConfiguration: symbolConfig)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
        iconCircleView.layer.borderColor = color.cgColor
        captionLabel.text = isRight ? "알아요" : "몰라요"
        captionLabel.textColor = color
    }
}
