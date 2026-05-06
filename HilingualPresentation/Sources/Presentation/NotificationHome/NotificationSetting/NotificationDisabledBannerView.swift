//
//  NotificationDisabledBannerView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 4/28/26.
//

import UIKit
import SnapKit

final class NotificationDisabledBannerView: BaseUIView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "중요한 알림을 놓치지 마세요!"
        label.font = .pretendard(.body_sb_14)
        label.textColor = .hilingualBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "기기의 알림 설정이 꺼져있어요. 휴대폰 설정> 알림> 하이링구얼 에서 설정을 변경해 주세요."
        label.font = .pretendard(.body_r_14)
        label.textColor = .hilingualBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .icArrowRight16Ios), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Setting Methods

    override func setUI() {
        backgroundColor = .gray100
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubviews(titleLabel, bodyLabel, settingButton)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        settingButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(bodyLabel)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(settingButton.snp.leading).offset(-4)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
