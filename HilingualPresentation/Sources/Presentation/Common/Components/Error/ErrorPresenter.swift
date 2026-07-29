//
//  ErrorPresenter.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

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

    func show(_ error: Error, form: ErrorDisplayForm, page: AnalyticsEvent.Page? = nil, retry: (() -> Void)? = nil) {
        let error = HilingualError.from(error)

        guard error != .unauthorized else { return }

        let resolvedForm: ErrorDisplayForm = (error == .network && form == .modal) ? .toast : form

        switch resolvedForm {
        case .fullPage:
            presentFullPage(spec: ErrorContentPolicy.fullPage(for: error), error: error, page: page, retry: retry)
        case .fullPageFeedback:
            presentFullPage(spec: ErrorContentPolicy.feedbackFullPage(), error: error, page: page, retry: retry)
        case .modal:
            presentModal(error: error, page: page, retry: retry)
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

    private func presentFullPage(spec: FullPageErrorSpec, error: HilingualError, page: AnalyticsEvent.Page?, retry: (() -> Void)?) {
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
            self?.track(Self.mainCTAAction(for: error), page: page)
            switch spec.role {
            case .retry:
                retry?()
            case .goBack:
                self?.goBack()
            }
        }

        errorView.configureBackButton(onTap: navStackCount > 1 ? { [weak self] in
            self?.track(Self.backCTAAction(for: error), page: page)
            self?.goBack()
        } : nil)

        container.addSubview(errorView)
        errorView.snp.makeConstraints { $0.edges.equalToSuperview() }
        fullPageView = errorView
    }

    // MARK: - Modal

    private func presentModal(error: HilingualError, page: AnalyticsEvent.Page?, retry: (() -> Void)?) {
        let businessAction: (() -> Void)? = (error == .dataNotFound) ? retry : nil
        let ctaAction: AnalyticsEvent.ErrorCTAAction = (error == .dataNotFound) ? .dataNotFoundGoBack : .serverErrorConfirm

        DialogManager.shared.show(
            message: ErrorContentPolicy.modalTitle(for: error),
            style: .error,
            confirmTitle: "확인",
            confirmAction: { [weak self] in
                self?.track(ctaAction, page: page)
                businessAction?()
            }
        )
    }

    // MARK: - Analytics

    private func track(_ action: AnalyticsEvent.ErrorCTAAction?, page: AnalyticsEvent.Page?) {
        guard let action, let page else { return }
        AmplitudeManager.shared.send(.clickErrorCTA(page: page, action: action))
    }

    private static func mainCTAAction(for error: HilingualError) -> AnalyticsEvent.ErrorCTAAction {
        switch error {
        case .dataNotFound: return .dataNotFoundGoBack
        case .network: return .networkErrorRetry
        default: return .serverErrorRetry
        }
    }

    private static func backCTAAction(for error: HilingualError) -> AnalyticsEvent.ErrorCTAAction? {
        switch error {
        case .dataNotFound: return .dataNotFoundGoBack
        case .network: return nil
        default: return .serverErrorGoBack
        }
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
