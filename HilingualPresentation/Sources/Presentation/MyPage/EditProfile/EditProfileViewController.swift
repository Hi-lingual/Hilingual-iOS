//
//  EditProfileViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine
import Foundation
import UIKit

public final class EditProfileViewController: BaseUIViewController<EditProfileViewModel> {

    // MARK: - Properties

    private let editProfileView = EditProfileView()

    // MARK: - Life Cycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func setUI() {
        super.setUI()
        view.addSubviews(editProfileView)
    }

    public override func setLayout() {
        editProfileView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("내 정보 수정")
    }

    public override func addTarget() {
        editProfileView.profileImageView.editButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func profileTapped() {
        editProfileView.modal.isHidden = false
        editProfileView.modal.showAnimation()
    }

    // MARK: - Bind

    public override func bind(viewModel: EditProfileViewModel) {
        let output = viewModel.transform(input: .init())

        output.userProfilePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profile in
                guard let profile else { return }
                self?.editProfileView.configure(
                    profileImageURL: profile.profileImg,
                    nickname: profile.nickname,
                    provider: profile.provider
                )
            }
            .store(in: &cancellables)
    }
}
