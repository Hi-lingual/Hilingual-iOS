//
//  CalendarHeaderView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/7/25.
//


import UIKit
import SnapKit

final class CalendarHeaderView: UIView {

    // MARK: - State

    private var currentDate: Date = Date() {
        didSet {
            textLabel.text = CalendarHeaderView.format(date: currentDate)
        }
    }

    var onMonthChanged: ((Date) -> Void)?

    // MARK: - UI Components

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_18)
        label.textColor = .black
        return label
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrow_down_24_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let monthButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_arrow_left_g_24_ios", in: .module, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_arrow_right_g_24_ios", in: .module, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let datePickerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        return stack
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
        textLabel.text = CalendarHeaderView.format(date: currentDate)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {

        backgroundColor = .clear

        monthButton.addSubview(datePickerStack)

        buttonStack.addArrangedSubviews(previousButton, nextButton)
        datePickerStack.addArrangedSubviews(textLabel, iconView)

        addSubviews(monthButton, buttonStack)
    }

    private func setupLayout() {
        monthButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }

        datePickerStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        buttonStack.snp.makeConstraints {
            $0.centerY.equalTo(monthButton)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupActions() {
        monthButton.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func monthButtonTapped() {
        let monthPicker = MonthPickerModal()
        monthPicker.onDateSelected = { [weak self] selectedDate in
            self?.onMonthChanged?(selectedDate)
        }

        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) {
            monthPicker.show(in: window)
        }
    }

    @objc private func previousButtonTapped() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        else { return }
        onMonthChanged?(newDate)
    }

    @objc private func nextButtonTapped() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        else { return }
        onMonthChanged?(newDate)
    }

    // MARK: - Public Method

    func setCurrentDate(_ date: Date) {
        self.currentDate = date
    }

    // MARK: - Helper

    private static func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 28)
    }
}
