//
//  CustomToggle.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/4/25.
//


import UIKit

final class CustomToggle: UIControl {

    // MARK: - Properties

    private(set) var isOn: Bool = false {
        didSet {
            updateUI(animated: true)
            sendActions(for: .valueChanged)
        }
    }

    // MARK: - UI Components

    private let backgroundView = UIView()
    private let thumbView = UIView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGesture()
    }

    // MARK: - Setup

    private func setupUI() {
        self.addSubview(backgroundView)
        backgroundView.layer.cornerRadius = 14
        backgroundView.backgroundColor = .lightGray
        backgroundView.clipsToBounds = true

        backgroundView.addSubview(thumbView)
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = 12
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowOpacity = 0.2
        thumbView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thumbView.layer.shadowRadius = 2

        updateUI(animated: false)
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        self.addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.frame = bounds
        let thumbSize: CGFloat = 24
        let thumbY = (bounds.height - thumbSize) / 2
        let thumbX = isOn ? bounds.width - thumbSize - 2 : 2
        thumbView.frame = CGRect(x: thumbX, y: thumbY, width: thumbSize, height: thumbSize)
    }

    // MARK: - Actions

    @objc private func toggle() {
        isOn.toggle()
    }

    // MARK: - UI Update

    private func updateUI(animated: Bool) {
        let thumbSize: CGFloat = 24
        let thumbY = (bounds.height - thumbSize) / 2
        let thumbX = isOn ? bounds.width - thumbSize - 2 : 2
        let newFrame = CGRect(x: thumbX, y: thumbY, width: thumbSize, height: thumbSize)

        let update = {
            self.backgroundView.backgroundColor = self.isOn ? .hilingualOrange : .lightGray
            self.thumbView.frame = newFrame
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: update)
        } else {
            update()
        }
    }

    // MARK: - Public API

    func setOn(_ on: Bool, animated: Bool) {
        self.isOn = on
        updateUI(animated: animated)
    }
}
