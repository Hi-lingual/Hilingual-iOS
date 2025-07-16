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
    
    // MARK: - Setup Method
    
    private func setUI() {
        backgroundColor = .black
        addSubviews(imageView, button)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Public Methods
    
    @objc public func close() {
        self.removeFromSuperview()
    }
}
