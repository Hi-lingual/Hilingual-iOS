//
//  WordBookStudyViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/15/26.
//

import UIKit
import SnapKit

@MainActor
final class WordBookStudyViewController: UIViewController {

    // MARK: - Properties

    private let words: [PhraseData]
    private let bufferSize = 3
    private let cardSpacing: CGFloat = 10

    private var index = 0
    private var loadedCards: [WordStudyCard] = []
    private var didSetupCards = false
    private var baseCardFrame: CGRect?

    // MARK: - Init

    init(words: [PhraseData]) {
        self.words = words
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func loadView() {
        view = WordBookStudyView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        configureSheet()
        updateRemainingCount()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didSetupCards {
            layoutCards(animated: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didSetupCards {
            view.layoutIfNeeded()
            loadInitialCards()
            didSetupCards = true
        }
    }

    private func addTarget() {
        studyView.backButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        studyView.notRememberedButton.addTarget(self, action: #selector(didTapNotRemembered), for: .touchUpInside)
        studyView.rememberedButton.addTarget(self, action: #selector(didTapRemembered), for: .touchUpInside)
        studyView.completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }

    @objc
    private func didTapNotRemembered() {
        loadedCards.first?.swipeLeft()
    }

    @objc
    private func didTapRemembered() {
        loadedCards.first?.swipeRight()
    }

    @objc
    private func didTapComplete() {
        dismiss(animated: true)
    }

    private func loadInitialCards() {
        guard !words.isEmpty else {
            studyView.emptyLabel.isHidden = false
            return
        }

        let maxIndex = min(bufferSize, words.count)
        for i in 0..<maxIndex {
            let card = createCard(for: i)
            if loadedCards.isEmpty {
                studyView.cardContainerView.addSubview(card)
            } else if let last = loadedCards.last {
                studyView.cardContainerView.insertSubview(card, belowSubview: last)
            }
            loadedCards.append(card)
        }

        layoutCards(animated: false)
        updateRemainingCount()
    }

    private func createCard(for index: Int) -> WordStudyCard {
        let card = WordStudyCard(word: words[index])
        card.delegate = self
        card.frame = cardFrame(at: loadedCards.count)
        return card
    }

    private func cardFrame(at position: Int) -> CGRect {
        ensureBaseCardFrame()
        let offset = CGFloat(position) * cardSpacing
        return (baseCardFrame ?? .zero).offsetBy(dx: 0, dy: offset)
    }

    private func layoutCards(animated: Bool) {
        guard !loadedCards.isEmpty else {
            studyView.showCompleteState()
            return
        }

        studyView.emptyLabel.isHidden = true

        for (i, card) in loadedCards.enumerated() {
            let frame = cardFrame(at: i)
            card.isUserInteractionEnabled = i == 0

            if card.transform != .identity {
                continue
            }

            if animated {
                UIView.animate(withDuration: 0.25) {
                    card.frame = frame
                }
            } else {
                card.frame = frame
            }
        }
    }

    private func advanceCards(from card: WordStudyCard) {
        guard let indexToRemove = loadedCards.firstIndex(where: { $0 === card }) else { return }
        loadedCards.remove(at: indexToRemove)
        index += 1

        if index + loadedCards.count < words.count {
            let newIndex = index + loadedCards.count
            let newCard = createCard(for: newIndex)
            if let last = loadedCards.last {
                studyView.cardContainerView.insertSubview(newCard, belowSubview: last)
            } else {
                studyView.cardContainerView.addSubview(newCard)
            }
            loadedCards.append(newCard)
        }

        layoutCards(animated: true)
        updateRemainingCount()
    }
}

private extension WordBookStudyViewController {
    var studyView: WordBookStudyView {
        guard let view = view as? WordBookStudyView else {
            fatalError("WordBookStudyViewController.view is not WordBookStudyView")
        }
        return view
    }

    func updateRemainingCount() {
        let remaining = max(words.count - index, 0)
        studyView.updateRemainingCount(remaining)
    }

    func configureSheet() {
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.large()]
        sheet.prefersGrabberVisible = false
        sheet.preferredCornerRadius = 28
    }

    func ensureBaseCardFrame() {
        guard baseCardFrame == nil else { return }
        let horizontalInset: CGFloat = 20
        let containerBounds = studyView.cardContainerView.bounds
        let maxHeight = min(containerBounds.height, 420)
        let minHeight: CGFloat = 240
        let cardHeight = max(minHeight, min(maxHeight, containerBounds.height * 0.72))
        let originY = max(8, (containerBounds.height - cardHeight) / 2)
        baseCardFrame = CGRect(
            x: horizontalInset,
            y: originY,
            width: containerBounds.width - (horizontalInset * 2),
            height: cardHeight
        )
    }
}

// MARK: - WordStudyCardDelegate

extension WordBookStudyViewController: WordStudyCardDelegate {
    func cardDidSwipeLeft(_ card: WordStudyCard) {
        advanceCards(from: card)
    }

    func cardDidSwipeRight(_ card: WordStudyCard) {
        advanceCards(from: card)
    }
}
