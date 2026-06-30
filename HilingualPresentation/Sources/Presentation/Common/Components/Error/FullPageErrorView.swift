//
//  FullPageErrorView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//


import UIKit
import SnapKit

final class FullPageErrorView: UIView {

    // MARK: - Content

    struct Content {
        let image: UIImage?
        let title: String
        let subtitle: String?
        let buttonTitle: String
        let placement: ButtonPlacement
        let fullWidthButton: Bool
    }

    enum ButtonPlacement {
        case belowText
        case bottom
    }

    // MARK: - Properties

    private var onButtonTap: (() -> Void)?
    private var onBackTap: (() -> Void)?

    // MARK: - UI Components

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_arrow_left_b_24_ios", in: .module, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_sb_18)
        label.textColor = .gray850
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray500
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .hilingualBlack
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(.body_m_16)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        return button
    }()

    private let centerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUI()
        addTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setUI() {
        addSubviews(centerStackView, backButton)
        centerStackView.addArrangedSubviews(imageView, titleLabel, subtitleLabel)
        centerStackView.setCustomSpacing(20, after: imageView)

        imageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(175)
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(44)
        }
    }

    private func addTarget() {
        actionButton.addAction(
            UIAction { [weak self] _ in self?.onButtonTap?() },
            for: .touchUpInside
        )
        backButton.addAction(
            UIAction { [weak self] _ in self?.onBackTap?() },
            for: .touchUpInside
        )
    }

    func configureBackButton(onTap: (() -> Void)?) {
        onBackTap = onTap
        backButton.isHidden = (onTap == nil)
    }

    // MARK: - Configure

    func configure(with content: Content, hasTabBar: Bool = false, onButtonTap: @escaping () -> Void) {
        self.onButtonTap = onButtonTap

        imageView.image = content.image
        imageView.isHidden = (content.image == nil)
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        subtitleLabel.isHidden = (content.subtitle == nil)
        actionButton.setTitle(content.buttonTitle, for: .normal)

        layoutButton(placement: content.placement, fullWidth: content.fullWidthButton, hasTabBar: hasTabBar)
    }

    // MARK: - Button Layout

    private func layoutButton(placement: ButtonPlacement, fullWidth: Bool, hasTabBar: Bool) {
        actionButton.removeFromSuperview()
        actionButton.snp.removeConstraints()
        centerStackView.snp.removeConstraints()
        addSubview(actionButton)

        switch placement {
        case .belowText where hasTabBar:
            actionButton.snp.makeConstraints {
                $0.bottom.equalTo(safeAreaLayoutGuide).inset(230)
                $0.centerX.equalToSuperview()
                if fullWidth {
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.height.equalTo(56)
                }
            }
            centerStackView.snp.makeConstraints {
                $0.bottom.equalTo(actionButton.snp.top).offset(-24)
                $0.centerX.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(24)
            }

        case .belowText:
            centerStackView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(24)
            }
            actionButton.snp.makeConstraints {
                $0.top.equalTo(centerStackView.snp.bottom).offset(24)
                $0.centerX.equalToSuperview()
                if fullWidth {
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.height.equalTo(56)
                }
            }

        case .bottom:
            centerStackView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(24)
            }
            actionButton.snp.makeConstraints {
                $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
                $0.centerX.equalToSuperview()
                if fullWidth {
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.height.equalTo(56)
                }
            }
        }
    }
}
