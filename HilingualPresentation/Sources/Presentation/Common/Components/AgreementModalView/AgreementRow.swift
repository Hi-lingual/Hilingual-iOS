//
//  AgreementRow.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/15/25.
//

import UIKit
import SnapKit
import SafariServices

final class AgreementRow: UIControl {

    // MARK: - Public
    var isChecked: Bool = false {
        didSet { updateAppearance() }
    }

    var onToggle: ((Bool) -> Void)?
    var onTapLink: (() -> Void)? {
        didSet {
            updateTitleUnderline()
        }
    }

    // MARK: - UI

    private let titleLabel = UILabel()
    private let checkImageView = UIImageView()
    private var isBold: Bool = false
    private var title: String = ""

    init(title: String, isBold: Bool = false) {
        super.init(frame: .zero)
        self.title = title
        self.isBold = isBold

        setupUI()
        addTarget(self, action: #selector(toggleChecked), for: .touchUpInside)
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    
    private func setupUI() {
        titleLabel.font = isBold ? .pretendard(.body_m_16) : .pretendard(.body_sb_14)
        titleLabel.textColor = .gray
        titleLabel.isUserInteractionEnabled = true
        updateTitleUnderline()

        checkImageView.image = UIImage(named: "ic_check_gray_28_ios", in: .module, compatibleWith: nil)
        checkImageView.contentMode = .scaleAspectFit

        addSubview(titleLabel)
        addSubview(checkImageView)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }

        snp.makeConstraints {
            $0.height.equalTo(48)
        }

        updateAppearance()
    }
    
    private func updateTitleUnderline() {
        let textColor: UIColor = isBold ? .hilingualBlack : .gray400
        
        if onTapLink != nil {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: isBold ? UIFont.pretendard(.body_m_16) : UIFont.pretendard(.body_m_14),
                .foregroundColor: textColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        } else {
            titleLabel.attributedText = NSAttributedString(
                string: title,
                attributes: [
                    .font: isBold ? UIFont.pretendard(.body_m_16) : UIFont.pretendard(.body_m_14),
                    .foregroundColor: textColor
                ]
            )
        }
    }

    private func updateAppearance() {
        let imageName = isChecked ? "ic_check_black_28_ios" : "ic_check_gray_28_ios"
        checkImageView.image = UIImage(named: imageName, in: .module, compatibleWith: nil)
    }

    @objc private func toggleChecked() {
        isChecked.toggle()
        onToggle?(isChecked)
    }

    // MARK: - Gesture
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        titleLabel.addGestureRecognizer(tap)
    }

    @objc private func titleTapped() {
        onTapLink?()
    }
}
