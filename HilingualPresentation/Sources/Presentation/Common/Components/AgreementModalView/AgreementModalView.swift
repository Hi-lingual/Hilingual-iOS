//
//  AgreementModalView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/15/25.
//

import UIKit
import SnapKit
import SafariServices

final class AgreementModalView: UIView {

    // MARK: - Public
    var onStart: (() -> Void)?

    public var isAdAgreeSelected: Bool {
        return marketingAgree.isChecked
    }

    // MARK: - UI Components

    private let dimmedBackgroundView = UIView()
    private let modalSheetView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let allAgreeContainer = UIView()
    private let stackView = UIStackView()
    private let startButton = CTAButton(style: .TextButton("시작하기"), autoBackground: false)

    // MARK: - Rows

    private let allAgree = AgreementRow(title: "전체 동의", isBold: true)
    private let serviceAgree = AgreementRow(title: "하이링구얼 서비스 이용약관 동의 (필수)")
    private let privacyAgree = AgreementRow(title: "개인정보 수집 및 이용 동의 (필수)")
    private let marketingAgree = AgreementRow(title: "앱 내 광고성 정보 수신 동의 (선택)")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupUI()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .clear
        dimmedBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(dimmedBackgroundView)
        dimmedBackgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        dimmedBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissModal)))
    }

    private func setupUI() {
        modalSheetView.backgroundColor = .white
        modalSheetView.layer.cornerRadius = 16
        modalSheetView.clipsToBounds = true
        addSubview(modalSheetView)

        titleLabel.attributedText = .pretendard(.head_sb_18, text: "하이링구얼이 처음이시군요!")
        titleLabel.textColor = .black

        descriptionLabel.text = "아래 약관에 동의 후 서비스 이용이 가능해요."
        descriptionLabel.font = .pretendard(.body_r_14)
        descriptionLabel.textColor = .gray

        allAgreeContainer.backgroundColor = .gray100
        allAgreeContainer.layer.cornerRadius = 12
        allAgreeContainer.addSubview(allAgree)

        stackView.axis = .vertical
        [serviceAgree, privacyAgree, marketingAgree].forEach {
            stackView.addArrangedSubview($0)
        }

        [titleLabel, descriptionLabel, allAgreeContainer, stackView, startButton].forEach {
            modalSheetView.addSubview($0)
        }
    }

    private func setupLayout() {
        modalSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }

        allAgreeContainer.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(52)
        }

        allAgree.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(allAgreeContainer.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }

        startButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(74)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(46)
        }
    }

    private func setupActions() {
        allAgree.onToggle = { [weak self] isChecked in
            self?.setAllAgreement(to: isChecked)
        }

        serviceAgree.onTapLink = { [weak self] in
            guard let url = URL(string: "https://hilingual.notion.site/230829677ebf817a8091f49423cbbb11"),
                  let vc = self?.parentViewController() else { return }
            let safariVC = SFSafariViewController(url: url)
            vc.present(safariVC, animated: true)
        }

        privacyAgree.onTapLink = { [weak self] in
            guard let url = URL(string: "https://hilingual.notion.site/230829677ebf8104b52ce74c65c27607"),
                  let vc = self?.parentViewController() else { return }
            let safariVC = SFSafariViewController(url: url)
            vc.present(safariVC, animated: true)
        }

        marketingAgree.onTapLink = nil

        [serviceAgree, privacyAgree, marketingAgree].forEach {
            $0.onToggle = { [weak self] _ in
                self?.updateAgreementState()
            }
        }
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        updateAgreementState()
    }

    // MARK: - Private Methods

    private func setAllAgreement(to checked: Bool) {
        [serviceAgree, privacyAgree, marketingAgree].forEach { $0.isChecked = checked }
        updateAgreementState()
    }

    private func updateAgreementState() {
        let requiredAgreed = serviceAgree.isChecked && privacyAgree.isChecked
        startButton.isEnabled = requiredAgreed
        startButton.backgroundColor = requiredAgreed ? .black : .gray300
        allAgree.isChecked = [serviceAgree, privacyAgree, marketingAgree].allSatisfy { $0.isChecked }
    }

    // MARK: - Animation
    
    public func showAnimation() {
        layoutIfNeeded()
        let height = modalSheetView.frame.height
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: height)
        self.backgroundColor = .clear

        UIView.animate(withDuration: 0.3) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.dim
            self.isHidden = false
        }
    }

    public func dismiss(completion: (() -> Void)? = nil) {
        layoutIfNeeded()
        let sheetHeight = modalSheetView.bounds.height

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: sheetHeight)
            self.backgroundColor = .clear
        }, completion: { _ in
            self.modalSheetView.transform = .identity
            self.isHidden = true
            completion?()
        })
    }

    @objc private func dismissModal() {
        dismiss()
    }

    @objc private func startButtonTapped() {
        UserDefaults.standard.set(true, forKey: "showHomeOnboarding")
        onStart?()
    }
}
