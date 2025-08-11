//
//  DetailImageView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/14/25.
//

import UIKit
import SnapKit

final class DetailImageView: UIView {
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_load_fail_large_ios", in: .module, with: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_close_24_w_ios", in: .module, with: nil), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    init(image: UIImage) {
        super.init(frame: .zero)
        imageView.image = image
        setUI()
        applyLayout(for: imageView.image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setUI() {
        backgroundColor = .black
        addSubviews(imageView, button)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(16.0 / 9.0)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    // MARK: - Layout Logic
    
    private func applyLayout(for image: UIImage?) {
        let target: CGFloat = 9.0 / 16.0
        let ratio: CGFloat = {
            guard let img = image, img.size.height > 0 else { return target }
            return img.size.width / img.size.height
        }()

        imageView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()

            if ratio < target {
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                $0.height.equalTo(imageView.snp.width).multipliedBy(16.0 / 9.0)
                $0.bottom.equalTo(safeAreaLayoutGuide)
            } else {
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = false
                $0.height.equalTo(imageView.snp.width).multipliedBy(1.0 / ratio)
                $0.centerY.equalToSuperview()
            }
        }

        bringSubviewToFront(button)
        setNeedsLayout()
        layoutIfNeeded()
    }

    func update(image: UIImage?) {
        guard let img = image else { return }
        imageView.image = img
        applyLayout(for: img)
    }
    
    // MARK: - Actions
    
    @objc public func close() {
        removeFromSuperview()
    }
}
