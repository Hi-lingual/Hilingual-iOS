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

    init?(count: Int) {
        if count == 7 || count == 30 || count == 50 {
            self = .blue
        } else if count >= 100 && count % 50 == 0 {
            self = count % 100 == 0 ? .orange : .blue
        } else {
            return nil
        }
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
        guard let style = MilestoneStyle(count: count) else { return }

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

    func renderImage(
        horizontalMargin: CGFloat = 16,
        cardVerticalPadding: CGFloat = 32,
        cardCornerRadius: CGFloat = 12
    ) -> UIImage {
        let originalRadius = layer.cornerRadius
        let originalClips = clipsToBounds
        layer.cornerRadius = 0
        clipsToBounds = false
        defer {
            layer.cornerRadius = originalRadius
            clipsToBounds = originalClips
        }

        let cardSize = CGSize(
            width: bounds.width,
            height: bounds.height + cardVerticalPadding * 2
        )

        let canvasWidth = cardSize.width + horizontalMargin * 2
        let canvasHeight = max(canvasWidth * 16 / 9, cardSize.height + horizontalMargin * 2)
        let canvasSize = CGSize(width: canvasWidth, height: canvasHeight)

        let cardRect = CGRect(
            x: (canvasWidth - cardSize.width) / 2,
            y: (canvasHeight - cardSize.height) / 2,
            width: cardSize.width,
            height: cardSize.height
        )

        let format = UIGraphicsImageRendererFormat()
        format.scale = 3
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        return renderer.image { _ in
            UIColor.gray100.setFill()
            UIRectFill(CGRect(origin: .zero, size: canvasSize))

            UIColor.white.setFill()
            UIBezierPath(roundedRect: cardRect, cornerRadius: cardCornerRadius).fill()

            drawHierarchy(
                in: CGRect(
                    x: cardRect.minX,
                    y: cardRect.minY + cardVerticalPadding,
                    width: bounds.width,
                    height: bounds.height
                ),
                afterScreenUpdates: true
            )
        }
    }
}
