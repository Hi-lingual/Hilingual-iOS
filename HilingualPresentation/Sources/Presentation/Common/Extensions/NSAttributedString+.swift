//
//  NSAttributedString+.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/11/25.
//


import UIKit

extension NSAttributedString {

    static func suit(_ style: UIFont.SuitStyle,
                     text: String,
                     lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSAttributedString {
        let font = UIFont.suit(style)

        let targets: Set<UIFont.SuitStyle> = [.body_sb_16, .body_m_16, .body_r_16]
        guard targets.contains(style) else {
            return NSAttributedString(string: text, attributes: [.font: font])
        }

        let multiple: CGFloat = 1.4
        let lineHeight = font.pointSize * multiple

        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = lineHeight
        paragraph.maximumLineHeight = lineHeight
        paragraph.lineBreakMode = lineBreakMode

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
    func applySuitFont(_ style: UIFont.SuitStyle, range: NSRange) {
        addAttributes([.font: UIFont.suit(style)], range: range)
    }
}
