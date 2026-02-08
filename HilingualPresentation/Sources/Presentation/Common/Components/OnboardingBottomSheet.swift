//
//  OnboardingBottomSheet.swift
//  HilingualPresentation
//
//  Created by 조영서 on 2/5/26.
//

import UIKit
import SnapKit

final class OnboardingBottomSheet: UIView {

    // MARK: - UI Components

    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .dim
        return view
    }()

    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "ic_close_44_black_ios", in: .module, compatibleWith: nil),
            for: .normal
        )
        return button
    }()

    private let onboardingLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 일기는\n48시간 동안 작성할 수 있어요."
        label.textAlignment = .center
        label.font = .pretendard(.head_sb_20)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private let onboardingImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(
            named: "img_onboarding_bottomsheet_1_ios",
            in: .module,
            compatibleWith: nil
        )
        return view
    }()

    private let barIndicatorImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(
            named: "bar_indicator_1_ios",
            in: .module,
            compatibleWith: nil
        )
        return view
    }()

    private let startButton = CTAButton(
        style: .TextButton("다음"),
        autoBackground: false
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup Methods

    private func setUI() {
        addSubviews(dimView, bottomSheetView)

        bottomSheetView.addSubviews(
            onboardingLabel,
            closeButton,
            onboardingImageView,
            barIndicatorImageView,
            startButton
        )
    }

    private func setLayout() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(44)
        }

        onboardingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
        }

        onboardingImageView.snp.makeConstraints {
            $0.top.equalTo(onboardingLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 343, height: 172))
        }

        barIndicatorImageView.snp.makeConstraints {
            $0.top.equalTo(onboardingImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 68, height: 8))
        }

        startButton.snp.makeConstraints {
            $0.top.equalTo(barIndicatorImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }

    private func bind() {
        closeButton.addAction(
            UIAction { [weak self] _ in
                self?.dismiss()
            },
            for: .touchUpInside
        )
    }

    // MARK: - Animation

    func showAnimation() {
        layoutIfNeeded()
        let height = bottomSheetView.frame.height

        bottomSheetView.transform = CGAffineTransform(translationX: 0, y: height)
        dimView.alpha = 0

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.bottomSheetView.transform = .identity
                self.dimView.alpha = 1
            }
        )
    }

    func dismiss() {
        let height = bottomSheetView.frame.height

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: height)
                self.dimView.alpha = 0
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}
