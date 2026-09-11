//
//  ReminderTimeSettingViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 9/6/26.
//

import UIKit
import Combine

public final class ReminderTimeSettingViewController: BaseUIViewController<ReminderTimeSettingViewModel> {

    private let reminderTimeSettingView = ReminderTimeSettingView()
    private let saveTappedSubject = PassthroughSubject<(hour: Int, minute: Int, weekdays: Set<Int>), Never>()

    private var isDailyRepeat = false
    private var selectedWeekdays: Set<Int> = []

    public override func loadView() {
        self.view = reminderTimeSettingView
    }
    
    private let dialog = Dialog()

    public override func navigationType() -> NavigationType? {
        return .backTitle("리마인드 시간 설정")
    }

    public override func bind(viewModel: ReminderTimeSettingViewModel) {
        let input = ReminderTimeSettingViewModel.Input(
            saveTapped: saveTappedSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)

        output.saveCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.navigationController?.popViewController(animated: true) }
            .store(in: &cancellables)
        
        output.saveError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.errorPresenter.show(error, form: .modal, page: .notificationSetting)
            }
            .store(in: &cancellables)
    }
    
    public override func addTarget() {
        reminderTimeSettingView.dailyRepeatToggle.setOn(false, animated: false)
        reminderTimeSettingView.weekdaySelector.setSelectedWeekdays([])
        reminderTimeSettingView.setSaveButtonEnabled(false)
        
        let dailyRepeatTap = UITapGestureRecognizer(target: self, action: #selector(dailyRepeatToggled))
        reminderTimeSettingView.dailyRepeatToggle.addGestureRecognizer(dailyRepeatTap)
        reminderTimeSettingView.dailyRepeatToggle.isUserInteractionEnabled = true
        
        reminderTimeSettingView.weekdaySelector.onSelectionChanged = { [weak self] weekdays in
            guard let self else { return }
            self.selectedWeekdays = weekdays
            
            if self.isDailyRepeat && weekdays.count < 7 {
                self.isDailyRepeat = false
                self.reminderTimeSettingView.dailyRepeatToggle.setOn(false, animated: true)
            }
            
            self.updateSaveButtonState()
        }

        reminderTimeSettingView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func dailyRepeatToggled() {
        isDailyRepeat.toggle()
        reminderTimeSettingView.dailyRepeatToggle.setOn(isDailyRepeat, animated: true)

        if isDailyRepeat {
            selectedWeekdays = Set(1...7)
            reminderTimeSettingView.weekdaySelector.setSelectedWeekdays(selectedWeekdays)
        } else {
            selectedWeekdays = []
            reminderTimeSettingView.weekdaySelector.setSelectedWeekdays(selectedWeekdays)
        }
        updateSaveButtonState()
    }

    private func updateSaveButtonState() {
        reminderTimeSettingView.setSaveButtonEnabled(!selectedWeekdays.isEmpty)
    }

    @objc private func saveTapped() {
        let date = reminderTimeSettingView.timePicker.date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        saveTappedSubject.send((hour: hour, minute: minute, weekdays: selectedWeekdays))
    }
    
    public override func backButtonTapped() {
        guard !selectedWeekdays.isEmpty else {
            navigationController?.popViewController(animated: true)
            return
        }
        showLeaveConfirmDialog()
    }

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard selectedWeekdays.isEmpty else { return false }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    private func showLeaveConfirmDialog() {
        guard let window = self.view.window else { return }
        window.addSubview(dialog)
        dialog.snp.remakeConstraints { $0.edges.equalToSuperview() }

        dialog.configure(
            style: .normal,
            title: "저장하지 않고 나가시겠어요?",
            content: "저장하지 않은 내용은 사라집니다.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "나가기",
            leftAction: { [weak self] in self?.dialog.dismiss() },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        )
        dialog.showAnimation()
    }
}
