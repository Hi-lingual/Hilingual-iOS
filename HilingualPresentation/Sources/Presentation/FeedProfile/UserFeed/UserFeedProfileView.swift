//
//  UserFeedProfileView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import SnapKit

final class UserFeedProfileView: BaseUIView {

    // MARK: - UI Components
    
    private let myFeedView = FeedProfileView()
    private let button = FollowButton()
    
    private let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        modal.configure(
            title: "",
            items: [
                ("계정 차단하기", UIImage(resource: .icCamera24Ios), {
                    print("계정 차단함 ㅋㅋ")
                }),
                ("계정 신고하기", UIImage(resource: .icGallary24Ios), {
                    print("계정 신고함 ㅋㅋ")
                })
            ]
        )
        return modal
    }()

    // MARK: - Setup

    override func setUI() {
        addSubviews(myFeedView, button, modal)
        button.configure(state: .follow)
    }

    override func setLayout() {
        myFeedView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(myFeedView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        modal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//private func addTarget() {
//    textScanButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
//}
//
//@objc private func showModal() {
//    modal.isHidden = false
//    modal.showAnimation()
//}
