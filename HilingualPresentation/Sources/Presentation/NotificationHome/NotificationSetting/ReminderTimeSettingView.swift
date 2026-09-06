//
//  ReminderTimeSettingView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 9/6/26.
//

import UIKit
import SnapKit

final class ReminderTimeSettingView: BaseUIView {

    // MARK: - UI Components

    private let alarmTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 시간"
        label.font = .pretendard(.body_m_15)
        label.textColor = .black
        return label
    }()

    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        return picker
    }()

    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.text = "반복 요일"
        label.font = .pretendard(.body_m_15)
        label.textColor = .black
        return label
    }()

    private let dailyRepeatLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 반복"
        label.font = .pretendard(.body_m_14)
        label.textColor = .gray500
        return label
    }()

    let dailyRepeatToggle = CustomToggle()

    private lazy var repeatHeaderStack: UIStackView = {
        let spacer = UIView()
        let stack = UIStackView(arrangedSubviews: [repeatLabel, spacer, dailyRepeatLabel, dailyRepeatToggle])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    let weekdaySelector = WeekdaySelectorView()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = .pretendard(.body_m_16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 12
        button.isEnabled = false
        return button
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [alarmTimeLabel, timePicker, repeatHeaderStack, weekdaySelector])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(24, after: timePicker)
        return stack
    }()

    // MARK: - Setting Methods

    override func setUI() {
        backgroundColor = .white
        addSubviews(contentStack, saveButton)
    }

    override func setLayout() {
        contentStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        timePicker.snp.makeConstraints {
            $0.height.equalTo(200)
        }

        weekdaySelector.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        dailyRepeatToggle.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }
        
        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(52)
        }
    }

    // MARK: - Public

    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .hilingualBlack : .gray300
    }
}
