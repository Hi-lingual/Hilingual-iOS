//
//  NotificationReminderModalView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 9/6/26.
//

import UIKit
import SnapKit

final class NotificationReminderModalView: BaseUIView {

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
            image: UIImage(resource: .imgRemindmodalwithimgIos),
            title: "알림이 꺼져있어요!",
            content: "알림을 켜면 리마인드 알림을 받고\n누가 당신의 일기에 반응했는지 바로 알 수 있어요.",
            leftButtonTitle: "나중에 보기",
            rightButtonTitle: "알림 설정 변경하기",
            leftAction: laterAction,
            rightAction: enableAction
        )
    }
}
