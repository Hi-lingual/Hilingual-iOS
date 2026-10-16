//
//  MilestoneCardView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 10/16/26.
//

import UIKit
import SnapKit

// MARK: - MilestoneStyle

enum MilestoneStyle {
    case blue
    case orange

    init(count: Int) {
        self = count % 100 == 0 ? .orange : .blue
    }

    var illustration: ImageResource {
        switch self {
        case .blue: return .imgMilestoneBlue
        case .orange: return .imgMilestoneOrange
        }
    }

    var accentColor: UIColor {
        switch self {
        case .blue: return .hilingualBlue
        case .orange: return .hilingualOrange
        }
    }

    func message(count: Int) -> (text: String, highlight: String) {
        let highlight = "\(count) stories"
        switch self {
        case .blue:
            return (
                "Way to go! You've written \(highlight) so far.\nBuild your own English diary with Hilingual.",
                highlight
            )
        case .orange:
            return (
                "WOW! You've written \(highlight) so far.\nKeep up the great work with Hilingual!",
                highlight
            )
        }
    }
}

final class MilestoneCardView: BaseUIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Milestone Unlocked"
        label.font = UIFont.pretendard(.head_sb_20)
        label.textColor = .hilingualBlack
        label.textAlignment = .center
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.head_eb_90)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()

    private let entriesLabel: UILabel = {
        let label = UILabel()
        label.text = "ENTRIES"
        label.font = UIFont.pretendard(.head_b_36)
        label.textColor = .hilingualBlack
        label.textAlignment = .center
        return label
    }()

    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgLogoSmallIos))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    // MARK: - Setup Methods

    override func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true

        addSubview(stackView)
        stackView.addArrangedSubviews(
            titleLabel,
            countLabel,
            entriesLabel,
            illustrationImageView,
            messageLabel,
            logoImageView
        )

        stackView.setCustomSpacing(0, after: titleLabel)
        stackView.setCustomSpacing(0, after: countLabel)
        stackView.setCustomSpacing(0, after: entriesLabel)
        stackView.setCustomSpacing(20, after: illustrationImageView)
        stackView.setCustomSpacing(20, after: messageLabel)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        illustrationImageView.snp.makeConstraints {
            $0.width.equalTo(295)
            $0.height.equalTo(152)
        }

        logoImageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(20)
        }
    }

    // MARK: - Configure

    func configure(count: Int) {
        let style = MilestoneStyle(count: count)

        countLabel.text = "\(count)"
        countLabel.textColor = style.accentColor
        illustrationImageView.image = UIImage(resource: style.illustration)

        let message = style.message(count: count)
        let font = UIFont.pretendard(.body_m_14)

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let attributed = NSMutableAttributedString(
            string: message.text,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.hilingualBlack,
                .paragraphStyle: paragraph
            ]
        )
        let range = (message.text as NSString).range(of: message.highlight)
        attributed.addAttribute(.foregroundColor, value: style.accentColor, range: range)

        messageLabel.attributedText = attributed
    }

    // MARK: - Render

    func renderImage(verticalPadding: CGFloat = 24) -> UIImage {
        let size = CGSize(width: bounds.width, height: bounds.height + verticalPadding * 2)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            drawHierarchy(
                in: CGRect(x: 0, y: verticalPadding, width: bounds.width, height: bounds.height),
                afterScreenUpdates: true
            )
        }
    }
}
