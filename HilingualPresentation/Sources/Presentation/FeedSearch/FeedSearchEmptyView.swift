//
//  FeedSearchEmptyView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import UIKit

final class FeedSearchEmptyView: BaseUIView {
    
    // MARK: - Properties
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .suit(.head_m_18)
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_search_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    private let emptyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubview(emptyStack)
        emptyStack.addArrangedSubviews(
            emptyImageView,
            emptyLabel
        )
    }
    
    override func setLayout() {
        emptyStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints {
            $0.width.equalTo(210)
            $0.height.equalTo(140)
        }
    }
}

