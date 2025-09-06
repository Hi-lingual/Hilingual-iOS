//
//  OnBoardingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import Foundation
import Combine
import PhotosUI

public final class OnBoardingViewController: BaseUIViewController<OnBoardingViewModel> {

    // MARK: - Properties

    private let onBoardingView = OnBoardingView()
    private let nicknameSubject = PassthroughSubject<String, Never>()
    private let startTappedSubject = PassthroughSubject<Bool, Never>()
    private let agreementModal = AgreementModalView()

    // MARK: - UI

    public override func setUI() {
        view.addSubviews(onBoardingView, agreementModal)
    }

    public override func setLayout() {
        onBoardingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        agreementModal.isHidden = true
        agreementModal.snp.makeConstraints { $0.edges.equalToSuperview() }

        bindModalCallbacks()
    }

    // MARK: - Custom Methods

    public override func navigationType() -> NavigationType? {
        .titleOnly("프로필 작성")
    }

    public override func addTarget() {
        onBoardingView.profileImageView.editButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        onBoardingView.nicknameTextField.textField.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)
        onBoardingView.startButton.addTarget(self, action: #selector(showAgreementModal), for: .touchUpInside)
    }

    // MARK: - Bind

    public override func bind(viewModel: OnBoardingViewModel) {

        let input = OnBoardingViewModel.Input(
            nicknameChanged: nicknameSubject.eraseToAnyPublisher(),
            startTapped: startTappedSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.nicknameState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.onBoardingView.nicknameTextField.updateState(state)
            }
            .store(in: &cancellables)

        output.startButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.onBoardingView.startButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)

        output.signUpResult
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let homeVC = diContainer.makeTabBarViewController()
                changeRootVC(homeVC, animated: true)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func bindModalCallbacks() {
        onBoardingView.onSelectDefaultImage = { [weak self] in
            self?.onBoardingView.profileImageView.profileImageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
            self?.viewModel?.selectedImageData = nil
        }

        onBoardingView.onSelectFromGallery = { [weak self] in
            self?.presentImagePicker()
        }
    }

    // MARK: - Actions

    @objc private func nicknameDidChange() {
        nicknameSubject.send(onBoardingView.nicknameTextField.text)
    }

    @objc private func showAgreementModal() {
        agreementModal.onStart = { [weak self] in
            guard let self else { return }
            let adAgree = self.agreementModal.isAdAgreeSelected
            self.startTappedSubject.send(adAgree)
        }
        agreementModal.isHidden = false
        agreementModal.showAnimation()
    }

    @objc private func profileTapped() {
        onBoardingView.modal.isHidden = false
        onBoardingView.modal.showAnimation()
    }
}

extension OnBoardingViewController: PHPickerViewControllerDelegate {

    func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

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
                self.onBoardingView.profileImageView.profileImageView.image = image

                if let data = image.jpegData(compressionQuality: 0.9) {
                    self.viewModel?.selectedImageData = data
                }
            }
        }
    }
}
