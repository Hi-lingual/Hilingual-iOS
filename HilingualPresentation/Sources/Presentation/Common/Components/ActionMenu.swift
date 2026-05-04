//
//  ActionMenu.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/11/25.
//

import UIKit
import SnapKit

// MARK: - Protocol

@MainActor
protocol ActionMenuDelegate: AnyObject {
    func actionMenu(_ menu: ActionMenu, didSelectItemAt index: Int)
}

final class ActionMenu: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ActionMenuDelegate?
   
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
    
    func configure(items: [(title: String, icon: UIImage?, titleColor: UIColor)]) {
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in items.enumerated() {
            let row = createMenuRow(
                title: item.title,
                icon: item.icon,
                titleColor: item.titleColor
            )
            row.tag = index
            
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(menuTapped(_:))
            )
            row.addGestureRecognizer(tap)
            
            stackView.addArrangedSubview(row)
            
            if index < items.count - 1 {
                let divider = UIView()
                divider.backgroundColor = .gray200
                stackView.addArrangedSubview(divider)
                divider.snp.makeConstraints { $0.height.equalTo(1) }
            }
        }
    }

    
    // MARK: - Private Methods
    
    private func createMenuRow(title: String, icon: UIImage?, titleColor: UIColor = .gray700) -> UIView {

        let container = UIView()

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .gray400
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(24)
        }

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendard(.body_m_14)
        titleLabel.textColor = titleColor

        stackView.addArrangedSubviews(iconView, titleLabel)

        container.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        return container
    }
    
    @objc private func menuTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        delegate?.actionMenu(self, didSelectItemAt: index)
    }
}
