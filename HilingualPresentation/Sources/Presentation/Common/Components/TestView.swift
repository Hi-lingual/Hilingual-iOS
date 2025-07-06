//
//  CTAButton.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/5/25.
//

import UIKit
import SnapKit

final class ExampleViewController: UIViewController {
    
    private let textField = UITextField()
    private let joinButton = CTAButton(style: .TextButton("가입하기"), autoBackground: true)
    private let join2Button = CTAButton(style: .IconTextButton(iconName: "ic_plus_16_ios", text: "일기 작성하기"))


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTextField()
        setupButton()
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        textField.borderStyle = .roundedRect
        textField.placeholder = "이메일을 입력하세요"
        
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        // 입력값 변화 감지
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupButton() {
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        view.addSubview(join2Button)

        join2Button.snp.makeConstraints {
            $0.top.equalTo(joinButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc private func textFieldDidChange() {
        let hasText = !(textField.text ?? "").isEmpty
        joinButton.isEnabled = hasText
    }
}


@available(iOS 17.0, *)
#Preview {
    ExampleViewController()
}
