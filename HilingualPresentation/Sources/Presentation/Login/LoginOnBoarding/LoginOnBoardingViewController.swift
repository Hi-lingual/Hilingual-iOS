//
//  LoginOnBoardingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import UIKit
import Combine
import SnapKit

public final class LoginOnBoardingViewController: BaseUIViewController<LoginOnBoardingViewModel> {

    // MARK: - View & State

    private let loginOnBoardingView = LoginOnBoardingView()

    private let pages = LoginOnBoardingModel.pages
    private var currentPage = 0

    // MARK: - Input

    private let startTappedSubject = PassthroughSubject<Void, Never>()


    // MARK: - Layout

    public override func setUI() {
        view.addSubviews(loginOnBoardingView)
    }

    public override func setLayout() {
        loginOnBoardingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        loginOnBoardingView.collectionView.dataSource = self
        loginOnBoardingView.collectionView.delegate = self
        applyPageState(animated: false)
    }

    // MARK: - Custom Method

    public override func addTarget() {
        loginOnBoardingView.nextButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        loginOnBoardingView.skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }

    public override func bind(viewModel: LoginOnBoardingViewModel) {
        let input = LoginOnBoardingViewModel.Input(
            startTapped: startTappedSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)

        output.navigateToLogin
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let vc = self.diContainer.makeLoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                changeRootVC(nav, animated: true)
            }
            .store(in: &cancellables)
    }

    // MARK: - Action Method

    @objc
    private func startTapped() {
        if currentPage < pages.count - 1 {
            moveToNextPage()
            return
        }
        UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
        print("[LoginOnBoardingVC] 💾 hasLoggedInBefore 저장: true")
        startTappedSubject.send()
    }

    @objc
    private func skipTapped() {
        UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
        print("[LoginOnBoardingVC] ⏭️ 건너뛰기 탭 - hasLoggedInBefore 저장: true")
        startTappedSubject.send()
    }

    // MARK: - Private Methods

    private func moveToNextPage() {
        setCurrentPage(currentPage + 1, animated: true)
        let indexPath = IndexPath(item: currentPage, section: 0)
        loginOnBoardingView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func applyPageState(animated: Bool) {
        let page = pages[currentPage]
        loginOnBoardingView.updateTitle(text: page.text, highlightText: page.highlightText, animated: animated)
        loginOnBoardingView.updateIndicator(currentIndex: currentPage, animated: animated)
    }

    private func updateCurrentPageIfNeeded(from scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / pageWidth))
        setCurrentPage(page, animated: true)
    }

    private func setCurrentPage(_ page: Int, animated: Bool) {
        let clampedPage = max(0, min(page, pages.count - 1))
        guard clampedPage != currentPage else { return }
        currentPage = clampedPage
        applyPageState(animated: animated)
    }
}

// MARK: - UICollectionViewDataSource

extension LoginOnBoardingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LoginOnBoardingPageCell.cellIdentifier,
            for: indexPath
        ) as? LoginOnBoardingPageCell else {
            return UICollectionViewCell()
        }
        cell.configure(imageName: pages[indexPath.item].imageName)
        return cell
    }
}

extension LoginOnBoardingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

// MARK: - ScrollView

extension LoginOnBoardingViewController {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentPageIfNeeded(from: scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPageIfNeeded(from: scrollView)
    }
}
