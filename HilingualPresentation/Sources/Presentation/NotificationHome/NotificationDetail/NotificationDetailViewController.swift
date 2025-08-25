//
//  NotificationDetailViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit
import Combine

public final class NotificationDetailViewController: BaseUIViewController<NotificationDetailViewModel> {

    // MARK: - Properties

    private let detailView = NotificationDetailView()
    private let appearSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life Cycle

    public override func loadView() {
        self.view = detailView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        appearSubject.send(())
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        return .backTitle("알림")
    }

    // MARK: - Bind

    private func bind() {
        guard let viewModel else { return }

        let input = NotificationDetailViewModel.Input(
            appear: appearSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.detail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.detailView.configure(with: detail)
            }
            .store(in: &cancellables)
    }
}
