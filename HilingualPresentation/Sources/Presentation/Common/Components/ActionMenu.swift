//
//  ActionMenu.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/11/25.
//

import UIKit
import SnapKit

final class ActionMenu: UIView {
    
    // MARK: - Properties
    private var actions: [() -> Void] = []
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        addSubview(stackView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(items: [(title: String, icon: UIImage?, action: () -> Void)]) {
        actions = items.map { $0.action }
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in items.enumerated() {
            let row = createMenuRow(title: item.title, icon: item.icon)
            row.tag = index
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(menuTapped(_:)))
            row.addGestureRecognizer(tap)
            
            stackView.addArrangedSubview(row)
            
            if index < items.count - 1 {
                let divider = UIView()
                divider.backgroundColor = .gray200
                divider.snp.makeConstraints { $0.height.equalTo(1) }
                
                stackView.addArrangedSubview(divider)
            }
        }
    }
    
    // MARK: - Private Methods
    private func createMenuRow(title: String, icon: UIImage?) -> UIView {
        
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.alignment = .center
        titleStackView.spacing = 8
        titleStackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        titleStackView.isLayoutMarginsRelativeArrangement = true
        
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .gray400
        iconView.snp.makeConstraints { $0.size.equalTo(24) }
        
        let textLabel = UILabel()
        textLabel.text = title
        textLabel.font = .suit(.body_sb_14)
        textLabel.textColor = .gray700
        
        titleStackView.addArrangedSubviews(iconView, textLabel)
        
        return titleStackView
    }
    
    @objc private func menuTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        actions[index]()
    }
}

// MARK: - Preview

#Preview {
    ActionMenuExampleViewController()
}
