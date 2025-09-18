//
//  FeedView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/18/25.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedView: BaseUIView {

    // MARK: - CallBacks

    var onProfileTapped: (() -> Void)?
    var onSegmentChanged: ((Int) -> Void)?
    var onToastAction: (() -> Void)?

    // MARK: - UI Components
    
    private(set) var segmentedControl: SegmentedControl?
    private let toast = ToastMessage()

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
        
        control.onIndexChanged = { [weak self] index in
            self?.onSegmentChanged?(index)
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
    
    func showToastMessage(message: String) {
        if toast.superview == nil {
            addSubview(toast)
        }
        
        toast.configure(type: .withButton, message: message, actionTitle: "보러가기")
        toast.action = { [weak self] in self?.onToastAction?()}
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

    func updateProfileImage(_ urlString: String?) {
        if let urlString = urlString?.trimmingCharacters(in: .whitespacesAndNewlines),
           !urlString.isEmpty,
           let url = URL(string: urlString) {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(
                    named: "img_profile_normal_ios",
                    in: .module,
                    compatibleWith: nil
                ),
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else {
            profileImageView.image = UIImage(
                named: "img_profile_normal_ios",
                in: .module,
                compatibleWith: nil
            )
        }
    }
    
    func setSelectedIndex(_ index: Int) {
        segmentedControl?.setSelectedIndexWithAPI = index
        onSegmentChanged?(index)
    }
    
    func setSelectedIndexUIOnly(_ index: Int) {
        guard let control = segmentedControl else { return }
        
        let original = control.onIndexChanged
        control.onIndexChanged = nil
        control.setSelectedIndexWithAPI = index
        control.onIndexChanged = original
    }

    //MARK: - Actions

    @objc private func didTapProfileImage() {
        onProfileTapped?()
    }
}
