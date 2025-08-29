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

    private var currentDiaryId: Int?
    private var currentIsPublished: Bool?
    
    // MARK: - Callback
    
    var onDiaryPreviewTapped: (() -> Void)?
    var onMoreButtonTapped: ((Bool?) -> Void)?
    var onMenuAction: ((MenuAction) -> Void)?
    
    // MARK: - UI Components

    internal let cardTopicView = CardTopicView()
    internal let cardPreview = CardPreview()
    private let emptyDiaryView = EmptyDiaryView()
    private let diaryLockView = DiaryLockView()

    private let selectedDayLabel: UILabel = {
        let label = UILabel()
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
    }

    private func setupLayout() {
        dot.snp.makeConstraints { $0.size.equalTo(2) }

        headerStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        [cardTopicView, cardPreview, emptyDiaryView, diaryLockView].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(headerStack.snp.bottom).offset(16)
                $0.horizontalEdges.equalToSuperview()
            }
        }

        moreImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        menu.snp.makeConstraints {
            $0.top.equalTo(moreImageView.snp.bottom).offset(4)
            $0.trailing.equalTo(moreImageView.snp.trailing)
            $0.height.equalTo(96)
            $0.width.equalTo(182)
        }
    }
    
    private func setDelegate() {
        menu.delegate = self
        menu.isHidden = true
    }
    
    // MARK: - Public

    func updateView(
        for date: Date,
        diaryId: Int?,
        isPublished: Bool? = nil,
        remainingTime: Int,
        topicData: (kor: String, en: String)? = nil,
        diaryData: String? = nil,
        imageURL: String? = nil
    ) {
        [cardPreview, cardTopicView, emptyDiaryView, diaryLockView, moreImageView].forEach {
            $0.isHidden = true
        }
        
        setSelectedDate(date)
        currentDiaryId = diaryId
        if let newIsPublished = isPublished {
            currentIsPublished = newIsPublished
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: date)

        iconView.isHidden = true
        timeLeftStack.isHidden = true

        // 아직 작성할 수 없는 미래의 날짜를 클릭 했을 경우
        if selectedDay > today {
            notWrittenLabel.text = "작성불가"
            notWrittenLabel.textColor = .gray300
            diaryLockView.isHidden = false
            return
        }

        // 일기가 있는 경우
        if let _ = diaryId {
            moreImageView.isHidden = false
            menu.isHidden = true
            updateMenuState(isPublished: currentIsPublished)
            
            cardPreview.isHidden = false
            if let imageURL, !imageURL.isEmpty {
                cardPreview.configure(type: .textWithImage(text: diaryData ?? "", imageUrl: imageURL))
            } else {
                cardPreview.configure(type: .textOnly(text: diaryData ?? ""))
            }
            return
        }

        // 48시간이 지난 날짜를 클릭했을 경우
        if remainingTime > 0, let topic = topicData {
            notWrittenLabel.text = "미작성"
            notWrittenLabel.textColor = .gray300
            cardTopicView.isHidden = false
            cardTopicView.configure(kor: topic.kor, en: topic.en)
            timeLeftLabel.attributedText = formatRemainingTime(remainingTime)
            iconView.isHidden = false
            timeLeftStack.isHidden = false
            moreImageView.isHidden = true
            return
        }

        notWrittenLabel.text = "미작성"
        notWrittenLabel.textColor = .gray300
        emptyDiaryView.isHidden = false
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
        guard currentDiaryId != nil else { return }
        
        updateMenuState(isPublished: currentIsPublished)
    }
    
    public func updateMenuState(isPublished: Bool?) {
        if let isPublished = isPublished {
            if isPublished { // 게시된 일기
                notWrittenLabel.text = "게시된 일기"
                notWrittenLabel.textColor = .hilingualBlue
                menu.configure(items: [
                    ("비공개하기", UIImage(named: "ic_hide_24_ios", in: .module, compatibleWith: nil), .gray700),
                    ("삭제하기", UIImage(named: "ic_delete_24_ios", in: .module, compatibleWith: nil), .alertRed)
                ])
            } else { // 비공개 일기
                notWrittenLabel.text = "비공개 일기"
                notWrittenLabel.textColor = .gray400
                menu.configure(items: [
                    ("게시하기", UIImage(named: "ic_upload_24_ios", in: .module, compatibleWith: nil), .gray700),
                    ("삭제하기", UIImage(named: "ic_delete_24_ios", in: .module, compatibleWith: nil), .alertRed)
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
    
    @objc private func cardPreviewTapped() {
        onDiaryPreviewTapped?()
    }

    // MARK: - Actions
    
    @objc private func moreButtonTapped() {
        onMoreButtonTapped?(currentIsPublished)
    }
}

// MARK: - Extensions

extension SelectedInfo: ActionMenuDelegate {
    func actionMenu(_ menu: ActionMenu, didSelectItemAt index: Int) {
        menu.isHidden = true
        guard currentDiaryId != nil else { return }

        switch index {
        case 0:
            if currentIsPublished == true {
                onMenuAction?(.unpublish)
            } else {
                onMenuAction?(.publish)
            }
        case 1:
            onMenuAction?(.delete)
        default: break
        }
    }
    
    private func showDialog(_ action: MenuAction) {
        onMenuAction?(action)
    }
}
