//
//  BaseUIViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import Combine
import Network

public class BaseUIViewController<VM: BaseViewBindable>: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    public var cancellables = Set<AnyCancellable>()
    public var viewModel: VM?
    public let diContainer: any ViewControllerFactory

    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")

    // MARK: - Init
    public init(viewModel: VM, diContainer: any ViewControllerFactory) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
        bind(viewModel: viewModel)
        setupNavigationBar()
        observeSessionExpired()
        observeServerError()
        observeNetworkStatus()
        HilingualLog.debug("[VC LifeCycle] \(Self.self) init")
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        setUI()
        setLayout()
        addTarget()
        setDelegate()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    // MARK: - Custom Method
    open func setUI() {}
    open func setLayout() {}
    open func addTarget() {}
    open func setDelegate() {}

    // MARK: - Bind Method
    open func bind(viewModel: VM) {
        self.viewModel = viewModel
    }

    // MARK: - Navigation
    open func navigationType() -> NavigationType? { nil }
    @objc open func backButtonTapped() { navigationController?.popViewController(animated: true) }
    @objc open func menuButtonTapped() {}
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }

    // MARK: - Session Expired
    private func observeSessionExpired() {
        NotificationCenter.default.publisher(for: Notification.Name("SessionExpired"))
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.handleSessionExpired()
            }
            .store(in: &cancellables)
    }

    private func handleSessionExpired() {
        let splashVC = diContainer.makeSplashViewController()
        let nav = UINavigationController(rootViewController: splashVC)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }

    // MARK: - Server Error
    
    private func observeServerError() {
        NotificationCenter.default.publisher(for: Notification.Name("ServerErrorOccurred"))
            .compactMap { $0.userInfo?["message"] as? String }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { message in
                DialogManager.shared.show(
                    message: message,
                    style: .error,
                    popOnConfirm: true
                )
            }
            .store(in: &cancellables)
    }

    // MARK: - Network Error

    private func observeNetworkStatus() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    self.handleNetworkDisconnected()
                }
            }
        }
        networkMonitor.start(queue: networkQueue)
    }

    @MainActor
    private func handleNetworkDisconnected() {
        DialogManager.shared.showNetworkError(
            using: networkMonitor)
    }

    // MARK: - Deinit
    deinit {
        HilingualLog.debug("[VC LifeCycle] \(Self.self) deinit")
        networkMonitor.cancel()
    }
}
