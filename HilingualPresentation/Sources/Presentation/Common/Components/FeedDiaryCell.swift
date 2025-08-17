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

    // MARK: - Properties
    
    static let identifier = "FeedDiaryCell"

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

    private let diaryLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_r_16)
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
    
    private let detailImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_arrow_right_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
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
    
    private let spacer1: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let spacer2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setUI() {
        contentView.addSubviews(containerStack, divider)

        containerStack.addArrangedSubviews(profileImageView, mainStack)
        
        mainStack.addArrangedSubviews(headerStack, diaryLabel, diaryImageView, spacer1, footerStack)

        headerStack.addArrangedSubviews(userInfoStack, moreImageView)
        
        userInfoStack.addArrangedSubviews(nameLabel,streakStack,spacer2, sharedDateLabel)
        
        streakStack.addArrangedSubviews(streakImageView,streakLabel)
        
        footerStack.addArrangedSubviews(detailImageView2, detailStack)
        
        detailStack.addArrangedSubviews(detailLabel, detailImageView)
    }

    private func setLayout() {
        
        containerStack.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.horizontalEdges.equalToSuperview()
        }
        
        //하트로 교체
        detailImageView2.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(42)
        }

        streakImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        moreImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        diaryImageView.snp.makeConstraints {
            $0.height.equalTo(182)
            $0.width.equalToSuperview()
        }

        detailImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        spacer1.snp.makeConstraints {
            $0.height.equalTo(0)
        }
        
        spacer2.snp.makeConstraints {
            $0.width.equalTo(0)
        }
        
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
        streak: Int = 0,
        sharedDateMinutes: Int,
        diaryPreviewText: String? = nil,
        diaryImageURL: String? = nil,
        isLast: Bool = false
    ) {
        nameLabel.text = nickname

        let streakValue = max(streak, 0)
        streakLabel.text = "\(streakValue)"
        streakLabel.textColor = streakValue > 0 ? .hilingualOrange : .gray400

        sharedDateLabel.text = sharedDateMinutes.asRelativeTimeTextKR

        if let preview = diaryPreviewText {
            diaryLabel.text = preview
        }

        if
            let urlString = profileImageURL,
            !urlString.isEmpty,
            let url = URL(string: urlString)
        {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
            )        } else {
            profileImageView.image = UIImage(
                named: "img_profile_normal_ios",
                in: .module,
                compatibleWith: nil
            )
        }
        
        if
            let urlString = diaryImageURL,
            !urlString.isEmpty,
            let url = URL(string: urlString)
        {
            diaryImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_load_fail_large_ios", in: .module, compatibleWith: nil)
            )
            diaryImageView.isHidden = false
        } else {
            diaryImageView.image = nil
            diaryImageView.isHidden = true
        }
        
        divider.isHidden = isLast
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.cancelDownloadTask()
        diaryImageView.kf.cancelDownloadTask()
        diaryImageView.isHidden = false
        divider.isHidden = false
    }
    
}
