//
//  MonthPickerViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/8/25.
//

import UIKit
import SnapKit

final class MonthPickerViewController: UIViewController {

    var onDateSelected: ((Date) -> Void)?
    
    private let datePicker = UIDatePicker()
    private let applyButton = CTAButton(style: .TextButton("적용하기"), autoBackground: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupLayout()
        setupActions()
    }

    private func setupUI() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")

        if #available(iOS 17.4, *) {
            datePicker.datePickerMode = .yearAndMonth
        } else {
            datePicker.datePickerMode = .date
        }

        view.addSubview(datePicker)
        view.addSubview(applyButton)
    }

    private func setupLayout() {
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        applyButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(19)
            $0.leading.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    private func setupActions() {
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }

    @objc private func applyButtonTapped() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true)
    }
}

#Preview {
    MonthPickerViewController()
}
