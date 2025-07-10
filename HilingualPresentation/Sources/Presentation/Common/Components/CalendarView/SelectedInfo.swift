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

    internal let selectedDateView = SelectedDateView()
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
        
        addSubviews(
            dot,
            selectedDayStack,
            timeLeftStack,
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

        cardTopicView.isHidden = true
        cardPreview.isHidden = true
        emptyDiaryView.isHidden = true
        diaryLockView.isHidden = true

    }

    private func setupLayout() {
        
        dot.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 2, height: 2))
        }
        
        selectedDayStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(12)
        }

        timeLeftStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(12)
        }
     
        [cardTopicView, cardPreview, emptyDiaryView, diaryLockView].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(timeLeftStack.snp.bottom).offset(12)
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
        cardTopicView.isHidden = true
        cardPreview.isHidden = true
        emptyDiaryView.isHidden = true
        diaryLockView.isHidden = true

        setSelectedDate(date)

        // 미래 날짜 처리
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: date)

        if selectedDay > today {
            diaryLockView.isHidden = false
            notWrittenLabel.text = "작성불가"
            notWrittenLabel.textColor = .gray300
            timeLeftLabel.text = ""
            return
        }

        notWrittenLabel.text = isWritten ? "작성완료" : "미작성"
        notWrittenLabel.textColor = isWritten ? .hilingualBlue : .gray300
        timeLeftLabel.textColor = isWritten ? .gray300 : .black

        if let createdAt = createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.locale = Locale(identifier: "ko_KR")
            if let date = formatter.date(from: createdAt) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "HH:mm"
                timeLeftLabel.text = displayFormatter.string(from: date)
            }
        } else {
            let hours = remainingTime / 60
            let fullText = "\(hours)시간 남았어요"
            let attributed = NSMutableAttributedString(string: fullText)
            attributed.addAttribute(.foregroundColor, value: UIColor.hilingualOrange, range: NSRange(location: 0, length: "\(hours)".count))
            timeLeftLabel.attributedText = attributed
        }

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
                emptyDiaryView.isHidden = false
            }
        }
    }

    func setSelectedDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        selectedDayLabel.text = formatter.string(from: date)
    }
}

// 일기 작성가능
#Preview {
    let view = SelectedInfo()
    let today = Date()
    view.updateView(
        for: today,
        isWritten: false,
        remainingTime: 120,
        topicData: (
            kor: "오늘 당신을 놀라게 한 일이 있었나요?",
            en: "What surprised you today?"
        )
    )
    return view
}

// 일기 확인 뷰 (홈뷰 버전)
#Preview {
    let view = SelectedInfo()
    let today = Date()
    view.setSelectedDate(today)
    view.updateView(
        for: today,
        isWritten: true,
        remainingTime: 0,
        createdAt: "2025-07-10T21:30:00",
        diaryData: "Today was the most stressful day in 2025 for me. It was the team building day at SOPT. I dreaded this day because I didn't know what to expe"
    )
    return view
}

// 시간 초과
#Preview {
    let view = SelectedInfo()
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    view.updateView(
        for: yesterday,
        isWritten: false,
        remainingTime: 0
    )
    return view
}


// 미래 날짜
#Preview {
    let view = SelectedInfo()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    view.updateView(
        for: tomorrow,
        isWritten: false,
        remainingTime: 0
    )
    return view
}
