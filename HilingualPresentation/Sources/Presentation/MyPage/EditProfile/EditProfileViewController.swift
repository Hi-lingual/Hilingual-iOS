//
//  EditProfileViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine
import Foundation
import UIKit
import PhotosUI

public final class EditProfileViewController: BaseUIViewController<EditProfileViewModel> {

    // MARK: - Properties

    private let editProfileView = EditProfileView()
    private lazy var pickerConfig: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        return config
    }()

    private let withdrawTappedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life Cycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func setUI() {
        super.setUI()
        view.addSubview(editProfileView)
    }

    public override func setLayout() {
        editProfileView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("내 정보 수정")
    }

    // MARK: - Bind

    public override func bind(viewModel: EditProfileViewModel) {
        let output = viewModel.transform(
            input: .init(withdrawTapped: withdrawTappedSubject.eraseToAnyPublisher())
        )

        output.withdrawSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let onboardingVC = self.diContainer.makeSplashViewController()
                changeRootVC(onboardingVC,animated: true)
            }
            .store(in: &cancellables)


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

        output.profileImageUploadSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                print("프로필 이미지 업로드 성공")
            }
            .store(in: &cancellables)

        output.profileImageUploadError
            .receive(on: RunLoop.main)
            .sink { error in
                // TODO: 실패 시 Alert 처리 등
                print("프로필 이미지 업로드 실패: \(error)")
            }
            .store(in: &cancellables)
    }

    // MARK: - Target

    public override func addTarget() {
        editProfileView.profileImageView.editButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        editProfileView.withdrawButton.addTarget(self, action: #selector(withdrawTapped), for: .touchUpInside)

        editProfileView.onSelectDefaultImage = { [weak self] in
            guard let self else { return }
            let defaultImage = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
            self.editProfileView.profileImageView.profileImageView.image = defaultImage

            if let data = defaultImage?.jpegData(compressionQuality: 0.9) {
                self.viewModel?.uploadProfileImage(data: data)
            }
        }

        editProfileView.onSelectGallery = { [weak self] in
            self?.presentImagePicker()
        }
    }

    // MARK: - Actions

    @objc private func profileTapped() {
        editProfileView.modal.isHidden = false
        editProfileView.modal.showAnimation()
    }

    @objc private func withdrawTapped() {
        let dialog = Dialog()
        guard let window = UIApplication.shared.windows.first else { return }

        dialog.configure(
            style: .normal,
            title: "정말 계정을 삭제하시겠어요?",
            content: "회원 탈퇴 시 작성한 일기를 비롯한 계정 정보는 \n영원히 삭제돼요. 정말 삭제를 원하시나요?",
            leftButtonTitle: "아니요",
            rightButtonTitle: "삭제하기",
            leftAction: {
                dialog.dismiss()
            },
            rightAction: { [weak self] in
                dialog.dismiss()
                self?.withdrawTappedSubject.send(())
            }
        )

        window.addSubview(dialog)
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dialog.showAnimation()
    }

    private func presentImagePicker() {
        let picker = PHPickerViewController(configuration: pickerConfig)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPicker Delegate

extension EditProfileViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else {
            return
        }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self, let image = object as? UIImage else { return }

            DispatchQueue.main.async {
                self.editProfileView.profileImageView.profileImageView.image = image

                if let data = image.jpegData(compressionQuality: 0.9) {
                    self.viewModel?.uploadProfileImage(data: data)
                }
            }
        }
    }
}
