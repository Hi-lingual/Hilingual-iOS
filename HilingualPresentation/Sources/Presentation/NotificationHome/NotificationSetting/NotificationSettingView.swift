//
//  NotificationSettingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/25/25.
//

import UIKit
import SnapKit

final class NotificationSettingView: BaseUIView {
    
    // MARK: - Properties
    
    var onBannerTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    let notificationBannerView = NotificationDisabledBannerView()
    let marketingToggle = CustomToggle()
    let feedToggle = CustomToggle()
    let reminderToggle = CustomToggle()

    private let marketingLabel: UILabel = {
        let label = UILabel()
        label.text = "마케팅 알림"
        label.font = .pretendard(.body_m_16)
        label.textColor = .black
        return label
    }()

    private let feedLabel: UILabel = {
        let label = UILabel()
        label.text = "피드 알림"
        label.font = .pretendard(.body_m_16)
        label.textColor = .black
        return label
    }()
    
    private let reminderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "일기 작성 리마인드 알림"
        label.font = .pretendard(.body_m_16)
        label.textColor = .black
        return label
    }()
    
    private let reminderSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.cap_r_12)
        label.textColor = .gray400
        return label
    }()
    
    private lazy var reminderTextStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [reminderTitleLabel, reminderSubtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private lazy var marketingRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [marketingLabel, marketingToggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var feedRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [feedLabel, feedToggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private lazy var reminderRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [reminderTextStack, reminderToggle])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var rowsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notificationBannerView, marketingRow, feedRow, separatorView, reminderRow])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    // MARK: - Custom Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        backgroundColor = .white
        notificationBannerView.isHidden = true
        addSubviews(rowsStack)
    }
    
    override func setLayout() {
        rowsStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        marketingToggle.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }

        feedToggle.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        reminderToggle.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }
    }
    
    private func setAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        notificationBannerView.addGestureRecognizer(tap)
        notificationBannerView.isUserInteractionEnabled = true
    }
    
    @objc private func bannerTapped() {
        onBannerTapped?()
    }

    // MARK: - Public Method

    func configure(marketingOn: Bool, feedOn: Bool, reminderOn: Bool) {
        marketingToggle.setOn(marketingOn, animated: false)
        feedToggle.setOn(feedOn, animated: false)
        reminderToggle.setOn(reminderOn, animated: false)
    }
    
    func setBannerVisible(_ visible: Bool) {
        notificationBannerView.isHidden = !visible
    }
    
    func setReminderSubtitle(_ text: String) {
        reminderSubtitleLabel.text = text
    }
}
