//
//  MonthPickerModal.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/17/25.
//

import UIKit
import SnapKit

final class MonthPickerModal: UIView {

    // MARK: - Properties

    public var onDateSelected: ((Date) -> Void)?

    private let modalSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 17.4, *) {
            picker.datePickerMode = .yearAndMonth
        } else {
            picker.datePickerMode = .date
        }
        return picker
    }()

    private let applyButton = CTAButton(style: .TextButton("적용하기"), autoBackground: false)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(modalSheetView)
        modalSheetView.addSubviews(datePicker, applyButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        modalSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        applyButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }

    private func setupAction() {
        applyButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.onDateSelected?(self.datePicker.date)
            self.dismiss()
        }, for: .touchUpInside)
    }

    // MARK: - Animation

    public func show(in parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }

        layoutIfNeeded()
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: modalSheetView.frame.height)
        self.backgroundColor = .clear

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.dim
        }
    }

    @objc public func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: self.modalSheetView.frame.height)
            self.backgroundColor = UIColor.dim.withAlphaComponent(0)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
