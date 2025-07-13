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

    internal let cardTopicView = CardTopicView()
    internal let cardPreview = CardPreview()
    private let emptyDiaryView = EmptyDiaryView()
    private let diaryLockView = DiaryLockView()

    
    private let selectedDayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
    
    private let spacer = UIView()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
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
        
        addSubviews(
            headerStack,
            cardTopicView,
            cardPreview,
            emptyDiaryView,
            diaryLockView
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
        
        headerStack.addArrangedSubviews(
            selectedDayStack,
            spacer,
            timeLeftStack
        )
        
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        cardTopicView.isHidden = true
        cardPreview.isHidden = true
        emptyDiaryView.isHidden = true
        diaryLockView.isHidden = true

    }

    private func setupLayout() {
        
        dot.snp.makeConstraints {
            $0.size.equalTo(2)
        }
        
        headerStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
     
        [cardTopicView, cardPreview, emptyDiaryView, diaryLockView].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(headerStack.snp.bottom)
                $0.horizontalEdges.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - Public Methods

    func updateView(
        for date: Date,
        isWritten: Bool,
        remainingTime: Int,
        createdAt: String? = nil,
        topicData: (kor: String, en: String)? = nil,
        diaryData: String? = nil
    ) {
        
        // 초기화
        [cardTopicView, cardPreview, emptyDiaryView, diaryLockView].forEach {
            $0.isHidden = true
        }
        
        setSelectedDate(date)

        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: date)

        // 1. 미래 날짜일 경우
        if selectedDay > today {
            notWrittenLabel.text = "작성불가"
            notWrittenLabel.textColor = .gray300
            timeLeftStack.isHidden = true
            diaryLockView.isHidden = false
            return
        }

        // 2. 작성완료, 미작성일 경우
        notWrittenLabel.text = isWritten ? "작성완료" : "미작성"
        notWrittenLabel.textColor = isWritten ? .hilingualBlue : .gray300
        timeLeftLabel.textColor = isWritten ? .gray300 : .black
        iconView.isHidden = isWritten
        timeLeftStack.isHidden = !isWritten && remainingTime == 0

        // 시간 표시
        if let createdAt = createdAt, isWritten {
            timeLeftLabel.text = formatCreatedAt(createdAt)
        } else {
            timeLeftLabel.attributedText = formatRemainingTime(remainingTime)
        }

        // 상태별 View 처리
        if isWritten {
            cardPreview.isHidden = false
            cardPreview.configure(type: .textWithImage(text: diaryData ?? "", imageUrl: "https://..."))
        } else if remainingTime > 0 {
            cardTopicView.isHidden = false
            if let topic = topicData {
                cardTopicView.configure(kor: topic.kor, en: topic.en)
            }
        } else {
            emptyDiaryView.isHidden = false
        }
    }

    // MARK: - Helpers
    
    private func formatCreatedAt(_ createdAt: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        guard let date = formatter.date(from: createdAt) else { return nil }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "HH:mm"
        return displayFormatter.string(from: date)
    }

    private func formatRemainingTime(_ remainingTime: Int) -> NSAttributedString {
        let hours = remainingTime / 60
        let fullText = "\(hours)시간 남았어요"
        let attributed = NSMutableAttributedString(string: fullText)
        attributed.addAttribute(
            .foregroundColor,
            value: UIColor.hilingualOrange,
            range: NSRange(location: 0, length: "\(hours)".count)
        )
        return attributed
    }

    func setSelectedDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        selectedDayLabel.text = formatter.string(from: date)
    }
}
