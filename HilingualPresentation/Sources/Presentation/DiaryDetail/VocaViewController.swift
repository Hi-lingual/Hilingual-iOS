//
//  RecommendedExpressionViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation
import UIKit

import Combine

public final class RecommendedExpressionViewController: BaseUIViewController<RecommendedExpressionViewModel>, ScrollControllable {
    
    // MARK: - Properties
    
    private let recommendedExpressionView = RecommendedExpressionView()
    private let dialog = Dialog()
    private var pendingDate: String?
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Custom Method
    
    public override func setUI() {
        view.addSubviews(recommendedExpressionView, dialog)
        view.backgroundColor = .gray100
        view.bringSubviewToFront(dialog)
        
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
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        // 에러 처리
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] viewDataList in
                    self?.recommendedExpressionView.configure(dataList: viewDataList)
                }
            )
            .store(in: &cancellables)
    }
    
    private func showErrorDialog(message: String) {
        dialog.configure(
            style: .error,
            image: UIImage(resource: .imgErrorIos),
            title: "앗! 일시적인 오류가 발생했어요.",
            rightButtonTitle: "확인",
            rightAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        
        dialog.showAnimation()
    }
    
    func scrollToTop() {
        recommendedExpressionView.scrollToTop()
    }
    
    func setDate(_ date: String) {
        pendingDate = date
        recommendedExpressionView.setDate(date)
    }

}
