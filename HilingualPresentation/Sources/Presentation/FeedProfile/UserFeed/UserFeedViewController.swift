//
//  UserFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation

public final class UserFeedProfileViewController: BaseUIViewController<UserFeedProfileViewModel> {

    // MARK: - Properties

    private let userFeedProfileView = UserFeedProfileView()
    
    private let input = UserFeedProfileViewModel.Input()

    public override func loadView() {
        self.view = userFeedProfileView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
//        bindViewModel()
        input.reload.send(())
    }

    // MARK: - Lifecycle

    public override func setUI() {
        super.setUI()
        view.addSubview(userFeedProfileView)
    }

    public override func setLayout() {
        userFeedProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    private func bindViewModel() {
//        let output = viewModel?.transform(input: input)
//        
//        output?.feeds
//            .receive(on: RunLoop.main)
//            .sink { [weak self] feeds in
//                guard let self else { return }
//                self.userFeedProfileView.apply(
//                    items: feeds,
//                    emptyMessage: "아직 공유한 일기가 없어요."
//                )
//            }
//            .store(in: &cancellables)
//    }
    
    public override func navigationType() -> NavigationType? {
        return.backTitleMenu("")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
