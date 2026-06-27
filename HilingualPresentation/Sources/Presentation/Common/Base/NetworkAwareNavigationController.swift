//
//  NetworkAwareNavigationController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

// 화면 이동(push) 시점에 이미 네트워크가 끊겨 있으면, 화면을 이동하지 않고 토스트로만 안내한다.
// (기획: 다른 화면으로 이동하기 전 네트워크 끊김을 감지하면 토스트. 탭 전환은 push 가 아니므로 제외)

import UIKit
import SnapKit
import HilingualCore

/// 오프라인 상태에서도 push 를 허용해야 하는 화면이 채택한다.
/// (예: AI 피드백 로딩 화면 - 진입 후 자체적으로 'AI 피드백 오류 페이지'로 안내하므로 가드 예외)
public protocol OfflineNavigable {}

public final class NetworkAwareNavigationController: UINavigationController {

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if NetworkMonitor.shared.isOffline, !(viewController is OfflineNavigable) {
            presentNetworkToast()
            return
        }
        super.pushViewController(viewController, animated: animated)
    }

    private func presentNetworkToast() {
        guard let hostView = topViewController?.view ?? viewIfLoaded else { return }
        let toast = ToastMessage()
        hostView.addSubview(toast)
        toast.configure(type: .basic, message: ErrorContentPolicy.toastMessage(for: .network))
    }
}
