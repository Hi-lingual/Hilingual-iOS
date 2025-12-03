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

        let targets: Set<UIFont.PretendardStyle> = [.body_m_16, .body_r_16, .body_m_15, .body_r_15]
        guard targets.contains(style) else {
            return NSAttributedString(string: text, attributes: [.font: font])
        }

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

        return NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraph,
                .baselineOffset: baseline
            ]
        )
    }
}

extension NSMutableAttributedString {
    func applyPretendardFont(_ style: UIFont.PretendardStyle, range: NSRange) {
        addAttributes([.font: UIFont.pretendard(style)], range: range)
    }
}
