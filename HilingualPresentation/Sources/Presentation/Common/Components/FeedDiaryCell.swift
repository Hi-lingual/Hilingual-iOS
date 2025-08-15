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
        stack.spacing = 2
        stack.alignment = .center
        return stack
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.textColor = .gray850
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
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

    private let spacer3: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        label.text = "I sent a message to my friend, but she didn’t reply all day. Maybe I said something wrong yesterday? Or maybe she’s just busy. I feel a little lonely today. I know I shouldn’t worry too much, but it’s"
        label.font = .suit(.body_r_16)
        label.textColor = .black
        label.numberOfLines = 5
        label.textAlignment = .left
        return label
    }()

    private let footerStack: UIStackView = {
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
        contentView.addSubview(containerStack)

        containerStack.addArrangedSubviews(profileImageView, mainStack)

        headerStack.addArrangedSubviews(
            nameLabel, streakStack, spacer1, sharedDateLabel, spacer2, moreImageView
        )
        streakStack.addArrangedSubviews(streakImageView, streakLabel)
        footerStack.addArrangedSubviews(detailLabel, detailImageView)
        mainStack.addArrangedSubviews(headerStack, diaryLabel, spacer3, footerStack)
    }

    private func setLayout() {
        
        containerStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

        detailImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        spacer1.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        spacer2.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        spacer3.snp.makeConstraints {
            $0.height.equalTo(0)
        }
    }

    // MARK: - Configure

    func configure(
        nickname: String = "이름을 입력해주세요",
        profileImageURL: String? = nil,
        streak: Int = 0,
        sharedDateText: String? = nil,
        diaryPreviewText: String? = nil
    ) {
        nameLabel.text = nickname

        let streakValue = max(streak, 0)
        streakLabel.text = "\(streakValue)"
        streakLabel.textColor = streakValue > 0 ? .hilingualOrange : .gray400

        if let shared = sharedDateText {
            sharedDateLabel.text = shared
        }

        if let preview = diaryPreviewText {
            diaryLabel.text = preview
        }

        if
            let urlString = profileImageURL,
            !urlString.isEmpty,
            let url = URL(string: urlString)
        {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(
                named: "img_profile_normal_ios",
                in: .module,
                compatibleWith: nil
            )
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = UIImage(
            named: "img_profile_normal_ios",
            in: .module,
            compatibleWith: nil
        )
        nameLabel.text = nil
        streakLabel.text = nil
        sharedDateLabel.text = nil
    }
}

#Preview {
    FeedDiaryExampleViewController()
}
