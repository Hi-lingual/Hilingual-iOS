//
//  RecommendedExpressionViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation

import Combine

public final class RecommendedExpressionViewController: BaseUIViewController<RecommendedExpressionViewModel>, ScrollControllable {
    
    // MARK: - Properties
    
    private let recommendedExpressionView = RecommendedExpressionView()
    private var pendingDate: String?
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = self.viewModel else { return }
            bind(viewModel: viewModel)
    }
    
    // MARK: Custom Method
    
    public override func setUI() {
        view.addSubview(recommendedExpressionView)
        view.backgroundColor = .gray100
        if let date = pendingDate {
                recommendedExpressionView.setDate(date)
            }
    }
    
    public override func setLayout() {
        recommendedExpressionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private let bookmarkToggleSubject = PassthroughSubject<(Int, Bool), Never>()

    public override func bind(viewModel: RecommendedExpressionViewModel) {
        recommendedExpressionView.onBookmarkToggle = { [weak self] phraseId, isBookmarked in
            self?.bookmarkToggleSubject.send((Int(phraseId), isBookmarked))
        }

        let input = RecommendedExpressionViewModel.Input(
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            bookmarkToggled: bookmarkToggleSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.fetchExpression
            .map { phraseList in
                phraseList.map {
                    PhraseViewData(
                        phraseId: Int64($0.phraseId),
                        phraseType: $0.phraseType,
                        phrase: $0.phrase,
                        explanation: $0.explanation,
                        reason: $0.reason,
                        isMarked: $0.isBookmarked,
                        createdAt: ""
                    )
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] viewDataList in
                self?.recommendedExpressionView.configure(dataList: viewDataList)
            }
            .store(in: &cancellables)
    }
    
    func scrollToTop() {
        recommendedExpressionView.scrollToTop()
    }
    
    func setDate(_ date: String) {
        pendingDate = date
        recommendedExpressionView.setDate(date)
    }

}
