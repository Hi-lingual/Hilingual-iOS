//
//  FeedDiaryCell.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/15/25.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedDiaryCell: UITableViewCell {
    
    // MARK: - Delegate
    
    @MainActor
    protocol FeedDiaryCellDelegate: AnyObject {
        func feedDiaryCell(_ cell: FeedDiaryCell, didTapMoreButton isMine: Bool)
        func feedDiaryCell(_ cell: FeedDiaryCell, didTapMenuItemAt index: Int, isMine: Bool)
    }

    // MARK: - Properties
    
    static let reuseIdentifier = "FeedDiaryCell"
    
    weak var delegate: FeedDiaryCellDelegate?
    private var isMine: Bool = false

    // MARK: - UI Components

    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .top
        return stack
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        return stack
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let userInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.textColor = .gray850
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let streakStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 1
        stack.alignment = .center
        return stack
    }()

    private let streakImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_fire_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    private let streakLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_14)
        return label
    }()

    private let sharedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_m_12)
        label.textColor = .gray400
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_more_24_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let menu = ActionMenu()

    private let diaryLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .suit(.body_r_16, text: "")
        label.textColor = .black
        label.numberOfLines = 5
        label.textAlignment = .left
        return label
    }()
    
    private let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let likeView = LikeCounterView(style: .horizontal)

    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        return stack
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "상세보기"
        label.textColor = .gray400
        label.font = .suit(.caption_r_14)
        return label
    }()

    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_arrow_right_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let spacer1 = UIView()
    private let spacer2 = UIView()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        menu.delegate = self
        setUI()
        setLayout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setUI() {
        contentView.addSubviews(containerStack, divider, menu)

        containerStack.addArrangedSubviews(profileImageView, mainStack)
        mainStack.addArrangedSubviews(headerStack, diaryLabel, diaryImageView, spacer1, footerStack)
        headerStack.addArrangedSubviews(userInfoStack, moreImageView)
        userInfoStack.addArrangedSubviews(nameLabel, streakStack, spacer2, sharedDateLabel)
        streakStack.addArrangedSubviews(streakImageView, streakLabel)
        footerStack.addArrangedSubviews(likeView, detailStack)
        detailStack.addArrangedSubviews(detailLabel, detailImageView)

        moreImageGesture()
    }

    private func moreImageGesture() {
        moreImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moreButtonTapped))
        moreImageView.addGestureRecognizer(tapGesture)
    }

    private func setLayout() {
        containerStack.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        menu.snp.makeConstraints {
            $0.top.equalTo(moreImageView.snp.bottom).offset(4)
            $0.height.equalTo(48)
            $0.width.equalTo(182)
            $0.trailing.equalTo(moreImageView.snp.trailing)
        }
        
        likeView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(45)
        }
        
        profileImageView.snp.makeConstraints { $0.size.equalTo(42) }
        streakImageView.snp.makeConstraints { $0.size.equalTo(16) }
        moreImageView.snp.makeConstraints { $0.size.equalTo(24) }
        
        diaryImageView.snp.makeConstraints {
            $0.height.equalTo(182)
            $0.width.equalToSuperview()
        }

        detailImageView.snp.makeConstraints { $0.size.equalTo(16) }
        
        spacer1.snp.makeConstraints { $0.height.equalTo(0) }
        spacer2.snp.makeConstraints { $0.width.equalTo(0) }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(containerStack.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    // MARK: - Configure

    func configure(
        nickname: String = "이름을 입력해주세요",
        profileImageURL: String? = nil,
        isMine: Bool,
        streak: Int? = 0,
        sharedDateMinutes: Int,
        diaryPreviewText: String? = nil,
        diaryImageURL: String? = nil,
        isLiked: Bool = false,
        likeCount: Int = 0,
        isLast: Bool = false
    ) {
        self.isMine = isMine
        nameLabel.text = nickname
        
        // 메뉴 구성
        if isMine {
            menu.configure(items: [
                ("비공개하기", UIImage(named: "ic_hide_24_ios", in: .module, compatibleWith: nil), .gray700)
            ])
        } else {
            menu.configure(items: [
                ("게시글 신고하기", UIImage(named: "ic_report_24_ios", in: .module, compatibleWith: nil), .gray700)
            ])
        }
        menu.isHidden = true

        // streak
        let streakValue = max(streak ?? 0, 0)
        streakLabel.text = "\(streakValue)"
        streakLabel.textColor = streakValue > 0 ? .hilingualOrange : .gray400

        // 공유 날짜
        sharedDateLabel.text = sharedDateMinutes.timeToText

        // diary preview
        if let preview = diaryPreviewText {
            diaryLabel.attributedText = .suit(.body_r_16, text: preview)
        }

        // 프로필 이미지
        if let urlString = profileImageURL,
           !urlString.isEmpty,
           let url = URL(string: urlString) {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
            )
        } else {
            profileImageView.image = UIImage(
                named: "img_profile_normal_ios",
                in: .module,
                compatibleWith: nil
            )
        }
        
        // 다이어리 이미지
        if let urlString = diaryImageURL,
           !urlString.isEmpty,
           let url = URL(string: urlString) {
            diaryImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_load_fail_large_ios", in: .module, compatibleWith: nil)
            )
            diaryImageView.isHidden = false
        } else {
            diaryImageView.image = nil
            diaryImageView.isHidden = true
        }
        
        // 좋아요
        likeView.configure(likeCount: likeCount, isLiked: isLiked)

        divider.isHidden = isLast
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.cancelDownloadTask()
        diaryLabel.attributedText = .suit(.body_r_16, text: "")
        diaryImageView.kf.cancelDownloadTask()
        diaryImageView.isHidden = false
        likeView.configure(likeCount: 0, isLiked: false)
        divider.isHidden = false
    }
    
    // MARK: - Actions

    @objc private func moreButtonTapped() {
        menu.isHidden.toggle()
        delegate?.feedDiaryCell(self, didTapMoreButton: isMine)
    }
    
    func closeMenuIfNeeded() {
        if !menu.isHidden {
            menu.isHidden = true
        }
    }
}

// MARK: - Extensions

extension FeedDiaryCell: ActionMenuDelegate {
    func actionMenu(_ menu: ActionMenu, didSelectItemAt index: Int) {
        menu.isHidden = true
        delegate?.feedDiaryCell(self, didTapMenuItemAt: index, isMine: isMine)
    }
}
