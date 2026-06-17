//
//  HomeModal.swift
//  HilingualPresentation
//
//  Created by youngseo on 6/18/26.
//

import UIKit
import SnapKit

final class HomeModal: UIView, UIGestureRecognizerDelegate {
        
    // MARK: - UI Components
    
    private let modalSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_sb_16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray500
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let modalButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .hilingualOrange
        button.titleLabel?.font = .pretendard(.body_m_16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_14)
        label.textColor = .gray400
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    
    private var buttonAction: (() -> Void)?
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        modalButton.addTarget(self, action: #selector(didTapModalButton), for: .touchUpInside)
    }
    
    private func setUI() {
        addSubview(modalSheetView)
        modalSheetView.addSubviews(titleLabel, subtitleLabel, imageView, modalButton, buttonLabel)
    }
    
    private func setLayout() {
        modalSheetView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(modalSheetView).inset(34)
            $0.horizontalEdges.equalTo(modalSheetView).inset(24)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(modalSheetView).inset(24)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(modalSheetView).inset(24)
        }
        
        modalButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalTo(modalSheetView).inset(24)
        }
        
        buttonLabel.snp.makeConstraints {
            $0.top.equalTo(modalButton.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalTo(modalSheetView).inset(24)
        }
    }
    
    // MARK: - Gesture

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        return !modalSheetView.frame.contains(location)
    }
    
    // MARK: - Actions
    
    public func showAnimation() {
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: modalSheetView.frame.height)
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.dim
        }
    }
    
    @objc public func dismissModal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: self.modalSheetView.frame.height)
            self.backgroundColor = UIColor.dim.withAlphaComponent(0)
        }, completion: { _ in
            self.isHidden = true
        })
    }
    
    @objc
    private func didTapModalButton() {
        buttonAction?()
    }
    
    // MARK: - Public Methods
    
    public func configure(
        title: String?,
        subtitle: String?,
        image: UIImage?,
        buttonTitle: String?,
        buttonText: String?,
        buttonAction: (() -> Void)?
    ) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
        modalButton.setTitle(buttonTitle, for: .normal)
        buttonLabel.text = buttonText
        self.buttonAction = buttonAction
    }
}
