//
//  NotificationPermissionModalView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 5/6/26.
//

import UIKit
import SnapKit

final class NotificationPermissionModalView: BaseUIView {
    
    // MARK: - UI Components
    
    let dialog = Dialog()
    
    // MARK: - Setting Methods
    
    override func setUI() {
        addSubview(dialog)
    }
    
    override func setLayout() {
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    func configure(laterAction: @escaping () -> Void, enableAction: @escaping () -> Void) {
        dialog.configure(
            style: .withImage,
            image: UIImage(resource: .imgModalwithimgIos),
            title: "중요한 소식을 놓치지 마세요.",
            content: "알림을 켜고 누가 당신의 일기에 반응했는지\n바로 확인해 보세요.",
            leftButtonTitle: "나중에 보기",
            rightButtonTitle: "알림 설정 변경하기",
            leftAction: laterAction,
            rightAction: enableAction
        )
    }
}
