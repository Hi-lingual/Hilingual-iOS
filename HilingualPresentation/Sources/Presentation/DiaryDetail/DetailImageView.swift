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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setUI() {
        backgroundColor = .black
        addSubviews(imageView, button)
        
        button.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Layout Logic
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyLayout(for: imageView.image)
    }
    
    private func applyLayout(for image: UIImage?) {
        let safe = safeAreaInsets
        let target: CGFloat = 9.0 / 16.0
        let ratio: CGFloat = {
            guard let img = image, img.size.height > 0 else { return target }
            return img.size.width / img.size.height
        }()
        
        let availableBounds = bounds.inset(by: safe)
        
        if ratio < target {
            // 세로가 더 긴 경우: 가로를 꽉 채우는 16:9 비율, 하단 고정
            let width = availableBounds.width
            let height = width * (16.0 / 9.0)
            let y = bounds.height - safe.bottom - height
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        } else {
            // 원본 비율 유지, 중앙 배치
            let width = availableBounds.width
            let height = width * (1.0 / ratio)
            let y = (bounds.height - height) / 2.0
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = false
        }

        bringSubviewToFront(button)
    }

    func update(image: UIImage?) {
        guard let img = image else { return }
        imageView.image = img
        setNeedsLayout()
    }
    
    // MARK: - Actions
    
    @objc public func close() {
        removeFromSuperview()
    }
}
