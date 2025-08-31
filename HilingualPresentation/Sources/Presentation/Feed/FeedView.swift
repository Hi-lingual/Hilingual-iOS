//
//  FeedView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/18/25.
//

import UIKit
import SnapKit

final class FeedView: BaseUIView {

    // MARK: - CallBacks

    var onProfileTapped: (() -> Void)?

    // MARK: - UI Components

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_18)
        label.text = "피드"
        return label
    }()

    private let searchStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 14
        stack.alignment = .center
        return stack
    }()

    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_search_24_ios", in: .module, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.tintColor = .gray400
        button.contentMode = .scaleAspectFit
        return button
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private var segmentedControl: SegmentedControl?
    
    private let toast = ToastMessage()

    // MARK: - Setup

    override func setUI() {
        addSubviews(headerStack, toast)
        headerStack.addArrangedSubviews(titleLabel, searchStack)
        searchStack.addArrangedSubviews(searchButton, profileImageView)

        toast.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
    }

    override func setLayout() {
        headerStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        searchButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(36)
        }
    }

    // MARK: - Public Method
    
    func configure(profileImageURL: String? = nil) {
        if let urlString = profileImageURL,
           !urlString.isEmpty,
           let url = URL(string: urlString) {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(
                named: "img_profile_normal_ios",
                in: .module,
                compatibleWith: nil
            )
        }
    }

    func configureSegmentedControl(
        parentVC: UIViewController,
        viewControllers: [UIViewController],
        titles: [String]
    ) {
        let control = SegmentedControl(
            viewControllers: viewControllers,
            titles: titles,
            parentViewController: parentVC
        )
        self.segmentedControl = control
        addSubview(control)

        control.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func showToast(message: String) {
        if toast.superview == nil {
            addSubview(toast)
        }
        
        toast.configure(type: .basic, message: message)
        toast.isHidden = false
        toast.alpha = 0
        bringSubviewToFront(toast)
        
        UIView.animate(withDuration: 0.3) {
            self.toast.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 0.3, animations: {
                self.toast.alpha = 0
            }, completion: { _ in
                self.toast.isHidden = true
            })
        }
    }

    //MARK: - Actions

    @objc private func didTapProfileImage() {
        onProfileTapped?()
    }
}
