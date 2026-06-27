//
//  NotificationSettingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/25/25.
//

import Foundation
import Combine

public final class NotificationSettingViewController: BaseUIViewController<NotificationSettingViewModel> {

    // MARK: - UI

    private let alarmSettingView = NotificationSettingView()

    // MARK: - Combine

    private let marketingToggledSubject = PassthroughSubject<Void, Never>()
    private let feedToggledSubject = PassthroughSubject<Void, Never>()
    private let reloadSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life Cycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func loadView() {
        self.view = alarmSettingView
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("알림 설정")
    }

    // MARK: - Bind

    public override func bind(viewModel: NotificationSettingViewModel) {
        let input = NotificationSettingViewModel.Input(
            viewDidLoad: Just(()).merge(with: reloadSubject).eraseToAnyPublisher(),
            marketingToggled: marketingToggledSubject.eraseToAnyPublisher(),
            feedToggled: feedToggledSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.isMarketingOn
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                self?.errorPresenter.dismiss()
                self?.alarmSettingView.marketingToggle.setOn(isOn, animated: true)
            }
            .store(in: &cancellables)

        output.isFeedOn
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                self?.alarmSettingView.feedToggle.setOn(isOn, animated: true)
            }
            .store(in: &cancellables)

        output.settingUpdateError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.errorPresenter.show(error, form: .modal)
            }
            .store(in: &cancellables)

        output.loadError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.errorPresenter.show(error, form: .fullPage) {
                    self?.reloadSubject.send(())
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Action

    public override func addTarget() {
        alarmSettingView.marketingToggle.addTarget(self, action: #selector(marketingSwitchToggled), for: .valueChanged)
        alarmSettingView.feedToggle.addTarget(self, action: #selector(feedSwitchToggled), for: .valueChanged)
    }

    @objc private func marketingSwitchToggled() {
        marketingToggledSubject.send(())
    }

    @objc private func feedSwitchToggled() {
        feedToggledSubject.send(())
    }
}
