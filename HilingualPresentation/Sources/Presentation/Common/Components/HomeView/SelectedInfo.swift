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
    
    var topicData: (String, String)? {
        return cardTopicView.topicData
    }
    
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
        
        iconView.isHidden = true
        timeLeftStack.isHidden = true
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
                $0.top.equalTo(headerStack.snp.bottom).offset(12)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - Public Methods
    
    func updateView(
        for date: Date,
        diaryId: Int?,
        remainingTime: Int,
        topicData: (kor: String, en: String)? = nil,
        diaryData: String? = nil,
        imageURL: String? = nil
    ) {
        [cardPreview, cardTopicView, emptyDiaryView, diaryLockView].forEach {
            $0.isHidden = true
        }
        
        setSelectedDate(date)

        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: date)

        iconView.isHidden = true
        timeLeftStack.isHidden = true

        if selectedDay > today {
            notWrittenLabel.text = "작성불가"
            notWrittenLabel.textColor = .gray300
            diaryLockView.isHidden = false
            return
        }

        if let _ = diaryId {
            notWrittenLabel.text = "작성완료"
            notWrittenLabel.textColor = .hilingualBlue

            cardPreview.isHidden = false
            if let imageURL, !imageURL.isEmpty {
                cardPreview.configure(type: .textWithImage(text: diaryData ?? "", imageUrl: imageURL))
            } else {
                cardPreview.configure(type: .textOnly(text: diaryData ?? ""))
            }
            return
        }

        if remainingTime > 0, let topic = topicData {
            notWrittenLabel.text = "미작성"
            notWrittenLabel.textColor = .gray300

            cardTopicView.isHidden = false
            cardTopicView.configure(kor: topic.kor, en: topic.en)
            timeLeftLabel.attributedText = formatRemainingTime(remainingTime)
            iconView.isHidden = false
            timeLeftStack.isHidden = false
            return
        }

        notWrittenLabel.text = "미작성"
        notWrittenLabel.textColor = .gray300
        emptyDiaryView.isHidden = false
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
        let fullText: String
        let highlightText: String

        if remainingTime >= 60 {
            let hours = remainingTime / 60
            highlightText = "\(hours)"
            fullText = "\(highlightText)시간 남았어요"
        } else {
            let minutes = max(1, remainingTime)
            highlightText = "\(minutes)"
            fullText = "\(highlightText)분 남았어요"
        }

        let attributed = NSMutableAttributedString(string: fullText)
        attributed.addAttribute(
            .foregroundColor,
            value: UIColor.hilingualOrange,
            range: (fullText as NSString).range(of: highlightText)
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
