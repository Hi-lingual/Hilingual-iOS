//
//  NSAttributedString+.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/11/25.
//

import UIKit

extension NSAttributedString {

    static func pretendard(_ style: UIFont.PretendardStyle,
                           text: String,
                           lineBreakMode: NSLineBreakMode = .byTruncatingTail,
                           forceWrap: Bool = false) -> NSAttributedString {

        let font = UIFont.pretendard(style)

        let kernPercentage: CGFloat? = {
            switch style {
            case .head_sb_18: return 0.03
            case .body_m_15: return 0.01
            case .body_r_15: return 0.01
            default: return nil
            }
        }()

        let lineHeightTargets: Set<UIFont.PretendardStyle> = [
            .body_m_16, .body_r_16, .body_m_15, .body_r_15
        ]

        if lineHeightTargets.contains(style) {

            let multiple: CGFloat = 1.4
            let lineHeight = font.pointSize * multiple

            let paragraph = NSMutableParagraphStyle()
            paragraph.minimumLineHeight = lineHeight
            paragraph.maximumLineHeight = lineHeight
            paragraph.lineBreakMode = lineBreakMode

            if forceWrap {
                paragraph.lineBreakStrategy = [.hangulWordPriority]
            }

            let baseline = (lineHeight - font.lineHeight) / 2

            var attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraph,
                .baselineOffset: baseline
            ]

            if let p = kernPercentage {
                attributes[.kern] = font.pointSize * p
            }

            return NSAttributedString(string: text, attributes: attributes)
        }

        if let p = kernPercentage {
            return NSAttributedString(
                string: text,
                attributes: [
                    .font: font,
                    .kern: font.pointSize * p
                ]
            )
        }

        return NSAttributedString(string: text, attributes: [.font: font])
    }
}

extension NSMutableAttributedString {
    func applyPretendardFont(_ style: UIFont.PretendardStyle, range: NSRange) {
        addAttributes([.font: UIFont.pretendard(style)], range: range)
    }
}
