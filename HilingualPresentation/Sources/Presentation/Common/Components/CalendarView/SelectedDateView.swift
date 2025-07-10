//
//  SelectedDateView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/10/25.
//

import UIKit
import SnapKit

final class SelectedDateView: UIView {

    // MARK: - UI Components

    private let selectedDayLabel: UILabel = {
        let label = UILabel()
        label.text = "8월 21일 목요일"
        label.font = .suit(.head_b_16)
        label.textColor = .black
        return label
    }()
    
    private let dot: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let notWrittenLabel: UILabel = {
        let label = UILabel()
        label.text = "미작성"
        label.font = .suit(.caption_m_12)
        label.textColor = .gray300
        return label
    }()
    
    private let selectedDayStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_time_16_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "48시간 남았어요"
        label.font = .suit(.body_sb_14)
        label.textColor = .black
        return label
    }()

    private let timeLeftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        
        backgroundColor = .white

        selectedDayStack.addArrangedSubviews(
            selectedDayLabel,
            dot,
            notWrittenLabel
        )
        
        timeLeftStack.addArrangedSubviews(
            iconView,
            timeLeftLabel
        )
        
        addSubviews(selectedDayStack, timeLeftStack)

    }

    private func setupLayout() {
        
        dot.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 2, height: 2))
        }
        
        selectedDayStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }

        timeLeftStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}

#Preview {
    SelectedDateView()
}
