//
//  NetworkAwareNavigationController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//


import UIKit
import SnapKit
import HilingualCore

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
