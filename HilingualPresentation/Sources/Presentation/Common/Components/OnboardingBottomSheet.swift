//
//  OnboardingBottomSheet.swift
//  HilingualPresentation
//
//  Created by 조영서 on 2/5/26.
//

import UIKit
import SnapKit

final class OnboardingBottomSheet: UIView {

    // MARK: - Properties

    private var currentStep: Int = 0

    private let onboardingTexts: [String] = [
        "오늘의 일기는\n48시간 동안 작성할 수 있어요.",
        "일기를 삭제한 날에는\n다시 일기를 작성할 수 없어요.",
        "작성한 일기는\n커뮤니티에 공유할 수 있어요.",
        "일상 속 영어 습관을\n만들 준비가 됐나요?"
    ]

    private let onboardingImages: [UIImage?] = [
        UIImage(named: "img_onboarding_bottomsheet_ios", in: .module, compatibleWith: nil),
        UIImage(named: "img_onboarding_bottomsheet_2_ios", in: .module, compatibleWith: nil),
        UIImage(named: "img_onboarding_bottomsheet_3_ios", in: .module, compatibleWith: nil),
        UIImage(named: "img_onboarding_bottomsheet_4_ios", in: .module, compatibleWith: nil)
    ]

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

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }()

    private let pageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let onboardingIndicatorView = OnBoardingIndicatorView()

    private let startButton = CTAButton(
        style: .TextButton("다음"),
        autoBackground: false
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setupPages()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup Methods

    private func setUI() {
        addSubviews(dimView, bottomSheetView)

        bottomSheetView.addSubviews(
            closeButton,
            scrollView,
            onboardingIndicatorView,
            startButton
        )
        
        scrollView.addSubview(pageStackView)
        scrollView.delegate = self
        
        closeButton.addAction(UIAction { [weak self] _ in self?.dismiss()}, for: .touchUpInside)
        startButton.addAction(UIAction { [weak self] _ in self?.showNextStep()}, for: .touchUpInside)
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

        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(onboardingIndicatorView.snp.top).offset(-16)
        }

        pageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        onboardingIndicatorView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(8)
        }

        startButton.snp.makeConstraints {
            $0.top.equalTo(onboardingIndicatorView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }

    // MARK: - Private Methods

    private func setupPages() {
        for i in 0..<onboardingTexts.count {
            let page = UIView()

            let label = UILabel()
            label.text = onboardingTexts[i]
            label.textAlignment = .center
            label.font = .pretendard(.head_sb_20)
            label.numberOfLines = 2

            let imageView = UIImageView(image: onboardingImages[i])
            imageView.contentMode = .scaleAspectFit

            page.addSubviews(label, imageView)
            pageStackView.addArrangedSubview(page)

            page.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
            }

            label.snp.makeConstraints {
                $0.top.centerX.equalToSuperview()
                $0.height.equalTo(48)
            }

            imageView.snp.makeConstraints {
                $0.top.equalTo(label.snp.bottom).offset(12)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(CGSize(width: 343, height: 172))
            }
        }

        onboardingIndicatorView.configure(count: onboardingTexts.count)
        onboardingIndicatorView.update(currentIndex: currentStep, animated: false)
    }

    private func showNextStep() {
        guard currentStep < onboardingTexts.count - 1 else {
            dismiss()
            return
        }

        currentStep += 1

        scrollView.setContentOffset(
            CGPoint(x: CGFloat(currentStep) * scrollView.bounds.width, y: 0),
            animated: true
        )

        onboardingIndicatorView.update(currentIndex: currentStep)
        startButton.setTitle(
            currentStep == onboardingTexts.count - 1 ? "시작하기" : "다음",
            for: .normal
        )
    }
    
    private func dismiss() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.bottomSheetView.transform =
                    CGAffineTransform(translationX: 0, y: self.bottomSheetView.frame.height)
                self.dimView.alpha = 0
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingBottomSheet: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentStep = Int(
            round(scrollView.contentOffset.x / scrollView.bounds.width)
        )

        onboardingIndicatorView.update(currentIndex: currentStep)
        startButton.setTitle(
            currentStep == onboardingTexts.count - 1 ? "시작하기" : "다음",
            for: .normal
        )
    }
}
