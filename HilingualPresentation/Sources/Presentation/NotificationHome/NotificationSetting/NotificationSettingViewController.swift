//
//  NotificationSettingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/25/25.
//

import Foundation
import Combine
import UIKit

public final class NotificationSettingViewController: BaseUIViewController<NotificationSettingViewModel> {
    
    private var isMarketingOn: Bool = false
    private var isFeedOn: Bool = false

    // MARK: - UI

    private let alarmSettingView = NotificationSettingView()
    private let dialog = Dialog()

    // MARK: - Combine

    private let marketingToggledSubject = PassthroughSubject<Void, Never>()
    private let feedToggledSubject = PassthroughSubject<Void, Never>()

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
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            marketingToggled: marketingToggledSubject.eraseToAnyPublisher(),
            feedToggled: feedToggledSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isMarketingOn
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                guard let self else { return }
                self.isMarketingOn = isOn
                self.alarmSettingView.marketingToggle.setOn(isOn, animated: true)
                self.alarmSettingView.setBannerVisible(!isOn || !self.isFeedOn)
            }
            .store(in: &cancellables)

        output.isFeedOn
            .receive(on: RunLoop.main)
            .sink { [weak self] isOn in
                guard let self else { return }
                self.isFeedOn = isOn
                self.alarmSettingView.feedToggle.setOn(isOn, animated: true)
                self.alarmSettingView.setBannerVisible(!self.isMarketingOn || !isOn)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action
    
    public override func addTarget() {
        alarmSettingView.onBannerTapped = { [weak self] in
            self?.openSystemSettings()
        }
        let marketingTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapped(_:)))
        alarmSettingView.marketingToggle.addGestureRecognizer(marketingTap)
        alarmSettingView.marketingToggle.isUserInteractionEnabled = true
        
        let feedTap = UITapGestureRecognizer(target: self, action: #selector(toggleTapped(_:)))
        alarmSettingView.feedToggle.addGestureRecognizer(feedTap)
        alarmSettingView.feedToggle.isUserInteractionEnabled = true
    }
    
    @objc private func toggleTapped(_ gesture: UITapGestureRecognizer) {
        guard let sender = gesture.view as? CustomToggle else { return }
        
        if !alarmSettingView.notificationBannerView.isHidden {
            showPermissionDialog()
        } else {
            let newState = !sender.isOn
            sender.setOn(newState, animated: true)
            
            if sender == alarmSettingView.marketingToggle {
                isMarketingOn = newState
                marketingToggledSubject.send(())
            } else {
                isFeedOn = newState
                feedToggledSubject.send(())
            }
        }
    }
    
    private func showPermissionDialog() {
        guard let window = self.view.window else { return }
        window.addSubview(dialog)
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }

        dialog.configure(
            style: .normal,
            title: "기기의 알림 설정이 꺼져있어요!",
            content: "휴대폰 설정 > 알림 > 하이링구얼에서\n설정을 변경해 주세요.",
            leftButtonTitle: "취소하기",
            rightButtonTitle: "확인",
            leftAction: { [weak self] in self?.dialog.dismiss() },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                self?.openSystemSettings()
            }
        )
        dialog.showAnimation()
    }
}
