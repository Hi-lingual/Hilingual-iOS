//
//  WordBookStudyViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/15/26.
//

import UIKit
import Combine

public final class WordBookStudyViewController: BaseUIViewController<WordBookStudyViewModel> {

    // MARK: - Properties

    private let words: [PhraseData]
    private let bufferSize = 3
    private let cardSpacing: CGFloat = 10

    private var index = 0
    private var loadedCards: [WordStudyCard] = []
    private var didSetupCards = false
    private var baseCardFrame: CGRect?
    private var currentState: WordBookStudyView.State = .studying

    // MARK: - Input Subjects

    private let cardSwipedSubject = PassthroughSubject<(phraseId: Int64, isMemorized: Bool), Never>()
    private let submitTappedSubject = PassthroughSubject<Void, Never>()
    private let retryRequestedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init

    public init(
        viewModel: WordBookStudyViewModel,
        diContainer: any ViewControllerFactory,
        words: [PhraseData]
    ) {
        self.words = words
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    // MARK: - Lifecycle

    public override func loadView() {
        view = WordBookStudyView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
        updateRemainingCount()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didSetupCards {
            layoutCards(animated: false)
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didSetupCards {
            view.layoutIfNeeded()
            loadInitialCards()
            didSetupCards = true
        }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        switch currentState {
        case .studying:
            let remaining = max(words.count - index, 0)
            return .backTitle("\(remaining)개")
        case .exitPrompt:
            return .closeOnly
        case .completed:
            return nil
        }
    }

    public override func backButtonTapped() {
        if viewModel?.hasAnyResult == true {
            setState(.exitPrompt)
        } else {
            dismiss(animated: true)
        }
    }

    public override func closeTapped() {
        setState(.studying)
    }

    // MARK: - Setup

    public override func addTarget() {
        studyView.notRememberedButton.addTarget(self, action: #selector(didTapNotRemembered), for: .touchUpInside)
        studyView.rememberedButton.addTarget(self, action: #selector(didTapRemembered), for: .touchUpInside)
        studyView.primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)
    }

    public override func bind(viewModel: WordBookStudyViewModel) {
        super.bind(viewModel: viewModel)

        let input = WordBookStudyViewModel.Input(
            cardSwiped: cardSwipedSubject.eraseToAnyPublisher(),
            submitTapped: submitTappedSubject.eraseToAnyPublisher(),
            retryRequested: retryRequestedSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)

        output.submitSucceeded
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

        output.actionError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self else { return }
                self.errorPresenter.show(error, form: .modal, page: .vocabulary) { [weak self] in
                    self?.retryRequestedSubject.send(())
                }
            }
            .store(in: &cancellables)

        output.isSubmitting
            .receive(on: RunLoop.main)
            .sink { [weak self] isSubmitting in
                self?.studyView.primaryButton.isEnabled = !isSubmitting
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

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
        submitTappedSubject.send(())
    }

    // MARK: - State

    private func setState(_ state: WordBookStudyView.State) {
        currentState = state
        studyView.setState(state)

        switch state {
        case .studying, .exitPrompt:
            navigationController?.setNavigationBarHidden(false, animated: false)
            setupNavigationBar()
        case .completed:
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
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
        setState(.completed)
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
        setupNavigationBar()
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
        cardSwipedSubject.send((phraseId: card.phraseId, isMemorized: false))
        advanceCards(from: card)
    }

    func cardDidSwipeRight(_ card: WordStudyCard) {
        cardSwipedSubject.send((phraseId: card.phraseId, isMemorized: true))
        advanceCards(from: card)
    }
}
