//
//  ErrorPresenter.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

// 화면(UIViewController)에 붙어 에러를 정책에 따라 표현하는 경량 헬퍼.
// 화면은 "이 에러를 어떤 형태로 보여줄지(form)"와 "다시 시도 동작(retry)"만 넘기면 된다.
// 실제 문구/이미지/버튼/내비게이션은 ErrorContentPolicy 가 결정한다.
//
// 사용 예 (ViewController):
//     output.loadError
//         .sink { [weak self] error in
//             self?.errorPresenter.show(error, form: .fullPage) {
//                 self?.reloadSubject.send(())   // 다시 시도
//             }
//         }
//     output.data
//         .sink { [weak self] data in
//             self?.errorPresenter.dismiss()     // 성공 시 에러 뷰 제거
//             ...
//         }

import UIKit
import SnapKit
import HilingualCore

@MainActor
final class ErrorPresenter {

    // MARK: - Properties

    private weak var host: UIViewController?
    private weak var fullPageView: FullPageErrorView?
    private var navBarWasHidden = false

    // MARK: - Init

    init(host: UIViewController) {
        self.host = host
    }

    // MARK: - Public

    func show(_ error: Error, form: ErrorDisplayForm, retry: (() -> Void)? = nil) {
        let error = HilingualError.from(error)

        guard error != .unauthorized else { return }

        let resolvedForm: ErrorDisplayForm = (error == .network && form == .modal) ? .toast : form

        switch resolvedForm {
        case .fullPage:
            presentFullPage(spec: ErrorContentPolicy.fullPage(for: error), retry: retry)
        case .fullPageFeedback:
            presentFullPage(spec: ErrorContentPolicy.feedbackFullPage(), retry: retry)
        case .modal:
            presentModal(error: error, retry: retry)
        case .toast:
            presentToast(error: error)
        }
    }

    func dismiss() {
        guard fullPageView != nil else { return }
        fullPageView?.removeFromSuperview()
        fullPageView = nil
        host?.navigationController?.setNavigationBarHidden(navBarWasHidden, animated: false)
        host?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - Full Page

    private func presentFullPage(spec: FullPageErrorSpec, retry: (() -> Void)?) {
        guard let host else { return }
        dismiss()

        let container: UIView = host.navigationController?.view ?? host.view

        navBarWasHidden = host.navigationController?.isNavigationBarHidden ?? true
        host.navigationController?.setNavigationBarHidden(true, animated: false)
        host.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        let navStackCount = host.navigationController?.viewControllers.count ?? 1
        let hasTabBar = host.customTabBarController != nil && navStackCount <= 1

        let errorView = FullPageErrorView(frame: container.bounds)
        errorView.configure(with: spec.content, hasTabBar: hasTabBar) { [weak self] in
            switch spec.role {
            case .retry:
                retry?()
            case .goBack:
                self?.goBack()
            }
        }

        errorView.configureBackButton(onTap: navStackCount > 1 ? { [weak self] in self?.goBack() } : nil)

        container.addSubview(errorView)
        errorView.snp.makeConstraints { $0.edges.equalToSuperview() }
        fullPageView = errorView
    }

    // MARK: - Modal

    private func presentModal(error: HilingualError, retry: (() -> Void)?) {
        let confirmAction: (() -> Void)? = (error == .dataNotFound) ? retry : nil

        DialogManager.shared.show(
            message: ErrorContentPolicy.modalTitle(for: error),
            style: .error,
            confirmTitle: "확인",
            confirmAction: confirmAction
        )
    }

    // MARK: - Toast

    private func presentToast(error: HilingualError) {
        guard let host else { return }
        let toast = ToastMessage()
        host.view.addSubview(toast)
        toast.configure(type: .basic, message: ErrorContentPolicy.toastMessage(for: error))
    }

    // MARK: - Navigation

    private func goBack() {
        guard let host else { return }
        dismiss()
        if let nav = host.navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            host.dismiss(animated: true)
        }
    }
}
