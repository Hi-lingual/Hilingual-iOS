//
//  OnBoardingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseUIView {

    //MARK: - UI Components

    let startButton: CTAButton = {
        let button =  CTAButton(style: .TextButton("적용하기"), autoBackground: true)
        return button
    }()

    let nicknameTextField: TextField = {
        let textfield = TextField()
        return textfield
    }()

    //MARK: - Custom Method

    override func setUI() {
        addSubviews(startButton,nicknameTextField)
    }

    override func setLayout() {
        startButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        nicknameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
