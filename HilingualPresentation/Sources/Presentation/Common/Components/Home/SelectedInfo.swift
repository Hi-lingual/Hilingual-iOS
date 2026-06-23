//
//  SelectedInfo.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/11/25.
//

import UIKit
import SnapKit

final class SelectedInfo: UIView {
    
    var topicData: (String, String)? {
        return cardTopicView.topicData
    }

    public var currentDiaryId: Int?
    private var currentIsPublished: Bool?
    private var overlayView: UIControl?
    
    // MARK: - Callback
    
    var onDiaryPreviewTapped: (() -> Void)?
    var onMoreButtonTapped: ((Bool?) -> Void)?
    var onMenuAction: ((MenuAction, Int) -> Void)?
    var onTapRecovery: (() -> Void)?
    
    // MARK: - UI Components

    internal let cardTopicView = CardTopicView()
    internal let cardPreview = CardPreview()
    private let recoveryView = RecoveryView()
    
    private let emptyDiaryView: EmptyView = {
        let view = EmptyView()
        view.configure(
            message: "작성된 일기가 없어요.\n좋은 하루 보내셨기를 바라요!",
            imageName: "img_diary_empty_ios",
            font: .pretendard(.body_m_14)
        )
        return view
    }()

    private let diaryLockView: EmptyView = {
        let view = EmptyView()
        view.configure(
            message: "아직 작성 가능한 시간이 아니에요.\n오늘의 일기를 작성해주세요!",
            imageName: "img_diary_lock_ios",
            font: .pretendard(.body_m_14)
        )
        return view
    }()

    private let selectedDayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_sb_16)
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
        label.font = .pretendard(.cap_r_12)
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
        label.font = .pretendard(.body_m_14)
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

    private(set) var moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_more_24_ios", in: .module, compatibleWith: nil)
        imageView.isHidden = true
        return imageView
    }()
    
    private(set) var menu: ActionMenu = {
        let menu = ActionMenu()
        menu.isHidden = true
        return menu
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setDelegate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .white

        addSubviews(
            headerStack,
            cardTopicView,
            cardPreview,
            emptyDiaryView,
            diaryLockView,
            recoveryView,
            menu
        )

        selectedDayStack.addArrangedSubviews(selectedDayLabel, dot, notWrittenLabel)
        timeLeftStack.addArrangedSubviews(iconView, timeLeftLabel)
        headerStack.addArrangedSubviews(selectedDayStack, spacer, timeLeftStack, moreImageView)

        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        [cardTopicView, cardPreview, emptyDiaryView, diaryLockView].forEach { $0.isHidden = true }
        iconView.isHidden = true
        timeLeftStack.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardPreviewTapped))
        cardPreview.addGestureRecognizer(tapGesture)
        cardPreview.isUserInteractionEnabled = true
        
        let moreTapGesture = UITapGestureRecognizer(target: self, action: #selector(moreButtonTapped))
        moreImageView.addGestureRecognizer(moreTapGesture)
        moreImageView.isUserInteractionEnabled = true
        
        recoveryView.onTapRecovery = { [weak self] in
            self?.onTapRecovery?()
        }
    }

    private func setupLayout() {
        dot.snp.makeConstraints { $0.size.equalTo(2) }

        headerStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        [cardTopicView, emptyDiaryView, diaryLockView, recoveryView].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(headerStack.snp.bottom).offset(16)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        cardPreview.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(74)
        }

        moreImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        menu.snp.makeConstraints {
            $0.top.equalTo(moreImageView.snp.bottom).offset(4)
            $0.trailing.equalTo(moreImageView.snp.trailing)
            // TODO: 일기 삭제 기능 재오픈 시 홈 메뉴 높이 원복 검토
            $0.height.equalTo(48)
            $0.width.equalTo(182)
        }
    }
    
    private func setDelegate() {
        menu.delegate = self
        menu.isHidden = true
    }
    
    private func setNotWrittenState(_ text: String, color: UIColor = .gray300) {
        dot.isHidden = false
        notWrittenLabel.isHidden = false
        notWrittenLabel.text = text
        notWrittenLabel.textColor = color
    }
    
    public func reset() {
        [cardPreview, cardTopicView, emptyDiaryView, diaryLockView, recoveryView, moreImageView, dot, notWrittenLabel, iconView, timeLeftStack].forEach {
            $0.isHidden = true
        }
    }
    
    // MARK: - Public

    func updateView(
        for date: Date,
        diaryId: Int?,
        isPublished: Bool? = nil,
        remainingTime: Int,
        topicData: (kor: String, en: String)? = nil,
        diaryData: String? = nil,
        imageURL: String? = nil,
        isRecovered: Bool = false
    ) {
        reset()
        
        setSelectedDate(date)
        currentDiaryId = diaryId
        if let newIsPublished = isPublished {
            currentIsPublished = newIsPublished
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        // 1. 일기가 있는 경우
        if let _ = diaryId {
            dot.isHidden = false
            notWrittenLabel.isHidden = false
            moreImageView.isHidden = false
            menu.isHidden = true
            updateMenuState(isPublished: currentIsPublished)
            cardPreview.isHidden = false
            
            if let imageURL, !imageURL.isEmpty {
                cardPreview.configure(type: .textWithImage(text: diaryData ?? "", imageUrl: imageURL))
            } else {
                cardPreview.configure(type: .textOnly(text: diaryData ?? ""))
            }
        }
        
        // 2. 미래인 경우
        else if selectedDay > today {
            setNotWrittenState("작성불가")
            diaryLockView.isHidden = false
        }
        
        // 3. Recovery로 해금된 경우
        else if isRecovered, let topic = topicData {
            setNotWrittenState("미작성")
            cardTopicView.isHidden = false
            cardTopicView.configure(kor: topic.kor, en: topic.en)

            iconView.isHidden = true
            timeLeftStack.isHidden = true
        }
        
        // 4. 남은 시간이 있고 주제가 있는 경우
        else if remainingTime > 0, let topic = topicData {
            setNotWrittenState("미작성")
            cardTopicView.isHidden = false
            cardTopicView.configure(kor: topic.kor, en: topic.en)
            timeLeftLabel.attributedText = formatRemainingTime(remainingTime)

            iconView.isHidden = false
            timeLeftStack.isHidden = false
        }
        
        // 4. 그 외의 모든 경우
        else {
            setNotWrittenState("미작성")

            // 이번 달 여부 판단
            let cal = Calendar.current
            let now = Date()
            let isSameMonth = cal.component(.year, from: date) == cal.component(.year, from: now) && cal.component(.month, from: date) == cal.component(.month, from: now)

            if isSameMonth {
                // 이번 달의 empty 상태 → RecoveryView 노출
                recoveryView.isHidden = false
                emptyDiaryView.isHidden = true
                cardTopicView.isHidden = true
                iconView.isHidden = true
                timeLeftStack.isHidden = true
            } else {
                // 이번 달이 아니면 기존 empty 메시지 유지
                emptyDiaryView.configure(
                    message: "작성된 일기가 없어요.\n좋은 하루 보내셨기를 바라요!",
                    imageName: "img_diary_empty_ios",
                    font: .pretendard(.body_m_14)
                )
                emptyDiaryView.isHidden = false
                recoveryView.isHidden = true
                cardTopicView.isHidden = true
            }
        }
    }

    func setSelectedDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        selectedDayLabel.text = formatter.string(from: date)
    }
    
    // MARK: - Private

    public func updateDiaryState(isPublished: Bool) {
        currentIsPublished = isPublished
        updateMenuState(isPublished: currentIsPublished)
    }
    
    public func updateMenuState(isPublished: Bool?) {
        if let isPublished = isPublished {
            if isPublished { // 게시된 일기
                notWrittenLabel.text = "게시된 일기"
                notWrittenLabel.textColor = .hilingualBlue
                menu.configure(items: [
                    ("비공개하기", UIImage(named: "ic_hide_24_ios", in: .module, compatibleWith: nil), .gray700)
                    // TODO: 일기 삭제 기능 재오픈 시 삭제 메뉴 항목 복구
//                    ("삭제하기", UIImage(named: "ic_delete_24_ios", in: .module, compatibleWith: nil), .alertRed)
                ])
            } else { // 비공개 일기
                notWrittenLabel.text = "비공개 일기"
                notWrittenLabel.textColor = .gray400
                menu.configure(items: [
                    ("피드에 게시하기", UIImage(named: "ic_upload_24_ios", in: .module, compatibleWith: nil), .gray700)
                    // TODO: 일기 삭제 기능 재오픈 시 삭제 메뉴 항목 복구
//                    ("삭제하기", UIImage(named: "ic_delete_24_ios", in: .module, compatibleWith: nil), .alertRed)
                ])
            }
        } else {
            menu.isHidden = true
            moreImageView.isHidden = true
        }
    }
    
    private func formatRemainingTime(_ remainingTime: Int) -> NSAttributedString {
        let fullText: String
        let highlightText: String

        if remainingTime >= 60 {
            let hours = Int(ceil(Double(remainingTime) / 60.0))
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
    
    @objc private func cardPreviewTapped() {
        onDiaryPreviewTapped?()
    }

    // MARK: - Actions
    
    @objc private func moreButtonTapped() {
        if menu.isHidden {
            onMoreButtonTapped?(currentIsPublished)
            menu.isHidden = false
        } else {
            menu.isHidden = true
        }
    }
}

// MARK: - Extensions

extension SelectedInfo: ActionMenuDelegate {
    func actionMenu(_ menu: ActionMenu, didSelectItemAt index: Int) {
        menu.isHidden = true
        guard let diaryId = currentDiaryId else { return }

        switch index {
        case 0:
            if currentIsPublished == true {
                onMenuAction?(.unpublish, diaryId)
            } else {
                onMenuAction?(.publish, diaryId)
            }
        // TODO: 일기 삭제 기능 재오픈 시 삭제 액션 분기 복구
//        case 1:
//            onMenuAction?(.delete, diaryId)
        default: break
        }
    }
}
