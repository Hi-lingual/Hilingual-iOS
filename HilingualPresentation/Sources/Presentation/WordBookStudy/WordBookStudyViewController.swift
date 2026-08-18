//
//  WordBookStudyViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/15/26.
//

import UIKit
import Combine
import HilingualDomain

final class WordBookStudyViewController: UIViewController {

    // MARK: - Properties

    private let words: [PhraseData]
    private let useCase: WordBookUseCase
    private let bufferSize = 3
    private let cardSpacing: CGFloat = 10

    private var index = 0
    private var loadedCards: [WordStudyCard] = []
    private var didSetupCards = false
    private var baseCardFrame: CGRect?
    private var memorizedResults: [Int64: Bool] = [:]
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(words: [PhraseData], useCase: WordBookUseCase) {
        self.words = words
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = WordBookStudyView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
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
        studyView.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        studyView.notRememberedButton.addTarget(self, action: #selector(didTapNotRemembered), for: .touchUpInside)
        studyView.rememberedButton.addTarget(self, action: #selector(didTapRemembered), for: .touchUpInside)
        studyView.primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc
    private func didTapBack() {
        if memorizedResults.isEmpty {
            dismiss(animated: true)
        } else {
            studyView.setState(.exitPrompt)
        }
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
    private func didTapPrimary() {
        submitAndDismiss()
    }

    // MARK: - Cards

    private func loadInitialCards() {
        guard !words.isEmpty else {
            showCompleteState()
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

    private func createCard(for cardIndex: Int) -> WordStudyCard {
        let word = words[cardIndex]
        let card = WordStudyCard(word: word)
        card.delegate = self
        card.frame = cardFrame(at: loadedCards.count)
        card.onFlipped = { [weak self] in
            self?.studyView.hideHint()
        }
        return card
    }

    private func cardFrame(at position: Int) -> CGRect {
        ensureBaseCardFrame()
        let offset = CGFloat(position) * cardSpacing
        return (baseCardFrame ?? .zero).offsetBy(dx: 0, dy: offset)
    }

    private func layoutCards(animated: Bool) {
        guard !loadedCards.isEmpty else {
            showCompleteState()
            return
        }

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

    private func showCompleteState() {
        studyView.setState(.completed)
    }

    // MARK: - API

    private func submitAndDismiss() {
        let items = memorizedResults.map { MemorizationEntity(phraseId: Int($0.key), isMemorized: $0.value) }
        guard !items.isEmpty else {
            dismiss(animated: true)
            return
        }

        studyView.primaryButton.isEnabled = false

        useCase.updateMemorization(items: items)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.studyView.primaryButton.isEnabled = true
                if case .failure = completion {
                    self?.dismiss(animated: true)
                }
            }, receiveValue: { [weak self] in
                self?.dismiss(animated: true)
            })
            .store(in: &cancellables)
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

    func ensureBaseCardFrame() {
        guard baseCardFrame == nil else { return }
        let horizontalInset: CGFloat = 20
        let containerBounds = studyView.cardContainerView.bounds
        let cardHeight: CGFloat = 400
        let originY = max(0, (containerBounds.height - cardHeight) / 2)
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
        recordResult(for: card, isMemorized: false)
        advanceCards(from: card)
    }

    func cardDidSwipeRight(_ card: WordStudyCard) {
        recordResult(for: card, isMemorized: true)
        advanceCards(from: card)
    }

    private func recordResult(for card: WordStudyCard, isMemorized: Bool) {
        memorizedResults[card.phraseId] = isMemorized
    }
}
