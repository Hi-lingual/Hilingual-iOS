//
//  LikeCounterView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/13/25.
//

import UIKit
import SnapKit

final class LikeCounterView: UIView {
    
    enum Style {
        case horizontal
        case vertical
    }
    
    // MARK: - Public State
    
    private(set) var isLiked: Bool = false {
        didSet {
            updateIcon()
            onToggle?(count, isLiked)
        }
    }
    
    private(set) var count: Int = 0 {
        didSet {
            updateCount()
            onToggle?(count, isLiked)
        }
    }
    
    var onToggle: ((Int, Bool) -> Void)?
    
    // MARK: - UI
    
    private let likeButton = UIButton(type: .custom)
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray850
        label.textAlignment = .left
        return label
    }()
    
    private let style: Style
    
    // MARK: - Init
    
    init(style: Style = .horizontal) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.style = .horizontal
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(likeButton)
        addSubview(countLabel)
        
        likeButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        updateIcon()
        updateCount()
        applyLayout()
    }
    
    private func applyLayout() {
        likeButton.snp.removeConstraints()
        countLabel.snp.removeConstraints()
        
        switch style {
        case .horizontal:
            countLabel.font = .suit(.body_sb_14)

            likeButton.snp.makeConstraints {
                $0.top.bottom.leading.equalToSuperview()
                $0.size.equalTo(24)
            }
            countLabel.snp.makeConstraints {
                $0.leading.equalTo(likeButton.snp.trailing).offset(4)
                $0.trailing.equalToSuperview()
                $0.centerY.equalTo(likeButton)
            }
        case .vertical:
            countLabel.font = .suit(.caption_m_12)
            
            likeButton.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.size.equalTo(24)
            }
            countLabel.snp.makeConstraints {
                $0.top.equalTo(likeButton.snp.bottom)
                $0.bottom.equalToSuperview()
                $0.centerX.equalTo(likeButton)
            }
        }
    }
    
    private func updateIcon() {
        let imageName = isLiked ? "ic_like_24_ios" : "ic_unlike_24_ios"
        likeButton.setImage(UIImage(named: imageName, in: .module, with: nil), for: .normal)
    }
    
    private func updateCount() {
        countLabel.text = "\(count)"
    }
    
    // MARK: - Actions
    
    @objc private func didTap() {
        isLiked.toggle()
        count = max(0, count + (isLiked ? 1 : -1))
    }
    
    func configure(count: Int, isLiked: Bool) {
        self.count = max(0, count)
        self.isLiked = isLiked
    }
}
