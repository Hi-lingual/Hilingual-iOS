//
//  NicknameEditViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/16/26.
//

import Combine
import Foundation
import UIKit

public final class NicknameEditViewController: BaseUIViewController<NicknameEditViewModel> {

    // MARK: - Properties

    public var onNicknameChanged: ((String) -> Void)?

    private let nicknameEditView = NicknameEditView()
    private let currentNickname: String
    private let nicknameSubject = PassthroughSubject<String, Never>()
    private let changeTappedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init

    public init(
        viewModel: NicknameEditViewModel,
        diContainer: any ViewControllerFactory,
        currentNickname: String
    ) {
        self.currentNickname = currentNickname
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        nicknameEditView.configure(nickname: currentNickname)
        nicknameSubject.send(currentNickname)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameEditView.nicknameTextField.textField.becomeFirstResponder()
    }

    // MARK: - Setup

    public override func setUI() {
        super.setUI()
        view.addSubview(nicknameEditView)
    }

    public override func setLayout() {
        nicknameEditView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func navigationType() -> NavigationType? {
        .backTitle("닉네임 변경")
    }

    public override func addTarget() {
        nicknameEditView.nicknameTextField.textField.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)
        nicknameEditView.changeButton.addTarget(self, action: #selector(changeTapped), for: .touchUpInside)
    }

    // MARK: - Bind

    public override func bind(viewModel: NicknameEditViewModel) {
        let input = NicknameEditViewModel.Input(
            nicknameChanged: nicknameSubject.eraseToAnyPublisher(),
            changeTapped: changeTappedSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.nicknameState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.nicknameEditView.nicknameTextField.updateState(state)
            }
            .store(in: &cancellables)

        output.changeButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.nicknameEditView.changeButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)

        output.updateSuccess
            .receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                self?.onNicknameChanged?(nickname)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        output.updateError
            .receive(on: RunLoop.main)
            .sink { error in
                print("닉네임 변경 실패: \(error)")
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc private func nicknameDidChange() {
        nicknameSubject.send(nicknameEditView.nicknameTextField.text)
    }

    @objc private func changeTapped() {
        changeTappedSubject.send(())
    }
}
