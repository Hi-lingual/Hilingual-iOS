//
//  Dialog.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/11/25.
//

import UIKit
import SnapKit

final class Dialog: UIView {
    
    // MARK: - enum
    
    enum DialogStyle {
        case normal
        case error
    }
    
    // MARK: - Properties
    
    private var leftAction: (() -> Void)?
    private var rightAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let dialogContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let dialogErrorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .imgErrorIos)
        imageView.isHidden = true
        return imageView
    }()
    
    private let dialogTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.textColor = .gray850
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let dialogContentLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_14)
        label.textColor = .gray400
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    public let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .suit(.body_sb_16)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    public let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .suit(.body_sb_16)
        button.backgroundColor = .hilingualOrange
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 13
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout(for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .dim2
        self.isHidden = true
    }
    
    private func setUI() {
        addSubviews(dialogContainerView)
        dialogContainerView.addSubviews(dialogErrorImageView,
                                        dialogTitleLabel,
                                        dialogContentLabel,
                                        buttonStackView)
        buttonStackView.addArrangedSubviews(leftButton, rightButton)
    }
    
    private func setLayout(for style: DialogStyle) {
        dialogContainerView.snp.removeConstraints()
        dialogErrorImageView.snp.removeConstraints()
        dialogTitleLabel.snp.removeConstraints()
        dialogContentLabel.snp.removeConstraints()
        buttonStackView.snp.removeConstraints()
        leftButton.snp.removeConstraints()
        rightButton.snp.removeConstraints()
        
        dialogContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
        }
        
        dialogErrorImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(175)
            $0.width.equalTo(200)
        }
        
        switch style {
        case .normal:
            dialogErrorImageView.isHidden = true
            dialogContentLabel.isHidden = false
            leftButton.isHidden = false
            
            dialogTitleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(34)
                $0.horizontalEdges.equalToSuperview().inset(24)
            }
            
            dialogContentLabel.snp.makeConstraints {
                $0.top.equalTo(dialogTitleLabel.snp.bottom).offset(8)
                $0.horizontalEdges.equalTo(dialogTitleLabel)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(dialogContentLabel.snp.bottom).offset(32)
                $0.horizontalEdges.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(24)
            }
            
            leftButton.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.width.equalTo(141)
            }
            
            rightButton.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.width.equalTo(141)
            }
            
        case .error:
            dialogErrorImageView.isHidden = false
            dialogContentLabel.isHidden = true
            leftButton.isHidden = true
            
            dialogTitleLabel.snp.makeConstraints {
                $0.top.equalTo(dialogErrorImageView.snp.bottom).offset(8)
                $0.horizontalEdges.equalToSuperview().inset(24)
            }
            
            buttonStackView.snp.makeConstraints{
                $0.top.equalTo(dialogTitleLabel.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(23)
                $0.bottom.equalToSuperview().inset(24)
            }
            
            rightButton.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func showAnimation() {
        dialogContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        dialogContainerView.alpha = 0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.dialogContainerView.transform = .identity
            self.dialogContainerView.alpha = 1
        }
    }
    
    func dismiss() {
        performDismissAnimation()
    }
    
    @objc func dismiss(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: dialogContainerView)
        if !dialogContainerView.bounds.contains(location) {
            performDismissAnimation()
        }
    }
    
    // MARK: - Private Methods
    
    private func performDismissAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dialogContainerView.alpha = 0
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
            self.alpha = 1
        })
    }
}

// MARK: - Extensions

extension Dialog {
    func configure(style: DialogStyle = .normal, image: UIImage? = nil, title: String,
                   content: String? = nil, leftButtonTitle: String? = nil, rightButtonTitle: String,
                   leftAction: (() -> Void)? = nil, rightAction: (() -> Void)? = nil) {
        
        dialogTitleLabel.text = title
        dialogContentLabel.text = content
        
        if let image = image {
            dialogErrorImageView.image = image
        }
        
        if let leftTitle = leftButtonTitle {
            leftButton.setAttributedTitle(.suit(.body_sb_16, text: leftTitle), for: .normal)
        }

        rightButton.setAttributedTitle(.suit(.body_sb_16, text: rightButtonTitle), for: .normal)
        
        self.leftAction = leftAction
        self.rightAction = rightAction
        
        leftButton.removeTarget(nil, action: nil, for: .allEvents)
        rightButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if leftAction != nil {
            leftButton.addAction(UIAction { [weak self] _ in
                self?.leftAction?()
                self?.dismiss()
            }, for: .touchUpInside)
        }
        
        rightButton.addAction(UIAction { [weak self] _ in
            self?.rightAction?()
            //self?.dismiss()
        }, for: .touchUpInside)

        self.gestureRecognizers?.forEach { self.removeGestureRecognizer($0) }
        if style == .normal {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
            self.addGestureRecognizer(tap)
        }

        setLayout(for: style)
    }
}


extension Dialog {
    func disableOutsideTapDismiss() {
        self.gestureRecognizers?.forEach { self.removeGestureRecognizer($0) }
    }

    func enableOutsideTapDismiss() {
        self.gestureRecognizers?.forEach { self.removeGestureRecognizer($0) }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        self.addGestureRecognizer(tap)
    }
}
