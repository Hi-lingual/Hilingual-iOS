//
//  SelectedInfo.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/11/25.
//

import UIKit
import SnapKit

// MARK: - SelectedInfo

final class SelectedInfo: UIView {

    // MARK: - UI Components

    private let selectedDateView = SelectedDateView()
    private let cardTopicView = CardTopicView()
    private let cardPreview = CardPreview()
    
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
    
//    private let headerStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.alignment = .fill
//        return stack
//    }()
    
    private let emptyDiaryLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 일기가 없어요.\n좋은 하루 보내셨기를 바라요!"
        label.font = .suit(.body_sb_14)
        label.textColor = .gray400
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let emptyDiaryView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_diary_empty_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let emptyDiaryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.backgroundColor = .white
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
        
        addSubviews(
            dot,
            selectedDayStack,
            timeLeftStack,
            //headerStack,
            cardTopicView,
            cardPreview,
            emptyDiaryStack
        )
        
        selectedDayStack.addArrangedSubviews(
            selectedDayLabel,
            dot,
            notWrittenLabel
        )
        
        timeLeftStack.addArrangedSubviews(
            iconView,
            timeLeftLabel
        )
        
//        headerStack.addArrangedSubviews(
//            selectedDayStack,
//            timeLeftStack
//        )
        
        emptyDiaryStack.addArrangedSubviews(
            emptyDiaryView,
            emptyDiaryLabel
        )

        cardTopicView.isHidden = true
        cardPreview.isHidden = true
        emptyDiaryStack.isHidden = true
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
     
        cardTopicView.snp.makeConstraints {
            $0.top.equalTo(timeLeftStack.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        cardPreview.snp.makeConstraints {
            $0.top.equalTo(timeLeftStack.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        emptyDiaryStack.snp.makeConstraints {
            $0.top.equalTo(timeLeftStack.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    // MARK: - Private Methods

    func updateView(
        isWritten: Bool,
        remainingTime: Int,
        topicData: (kor: String, en: String)? = nil,
        diaryData: String? = nil
    ) {
        cardTopicView.isHidden = true
        cardPreview.isHidden = true
        emptyDiaryStack.isHidden = true

        if isWritten {
            cardPreview.isHidden = false
            cardPreview.configure(type: .textWithImage(text: diaryData ?? "", imageUrl: "https://..."))
        } else {
            if remainingTime > 0 {
                cardTopicView.isHidden = false
                if let topic = topicData {
                    cardTopicView.configure(kor: topic.kor, en: topic.en)
                }
            } else {
                emptyDiaryStack.isHidden = false
            }
        }
    }
}

