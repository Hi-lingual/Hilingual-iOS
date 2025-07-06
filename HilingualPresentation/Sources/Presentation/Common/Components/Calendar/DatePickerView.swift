//
//  DatePickerView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/7/25.
//

import UIKit
import SnapKit

final class DatePickerView: UIView {

    // MARK: - Properties

    private let pickerView = UIPickerView()

    private let availableYear: [Int]
    private let allMonth = Array(1...12)

    private var selectedYear: Int
    private var selectedMonth: Int

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        let currentYear = Calendar.current.component(.year, from: Date())
        self.availableYear = Array((currentYear - 100)...(currentYear + 10))
        self.selectedYear = currentYear
        self.selectedMonth = Calendar.current.component(.month, from: Date())
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupPicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setupLayout() {
        pickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupPicker() {
        if let yearIndex = availableYear.firstIndex(of: selectedYear) {
            pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        pickerView.selectRow(selectedMonth - 1, inComponent: 1, animated: false)
    }

    // MARK: - Public API

    func getSelectedDate() -> (year: Int, month: Int) {
        return (selectedYear, selectedMonth)
    }

    func setDate(year: Int, month: Int, animated: Bool = false) {
        if let yearIndex = availableYear.firstIndex(of: year) {
            pickerView.selectRow(yearIndex, inComponent: 0, animated: animated)
            selectedYear = year
        }
        if (1...12).contains(month) {
            pickerView.selectRow(month - 1, inComponent: 1, animated: animated)
            selectedMonth = month
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension DatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? availableYear.count : allMonth.count
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width / 2
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text: String
        if component == 0 {
            text = "\(availableYear[row])년"
        } else {
            text = "\(allMonth[row])월"
        }
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.suit(.head_b_18),
            .foregroundColor: UIColor.black
        ])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYear = availableYear[row]
        } else {
            selectedMonth = allMonth[row]
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    DatePickerView()
}
