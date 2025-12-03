//
//  String+Markdown.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2025/09/17.
//

import UIKit

extension String {
    func toMarkdownAttributedString(font: UIFont = .pretendard(.body_r_16),
                                     textColor: UIColor = .gray850) -> NSAttributedString {
        let components = self.components(separatedBy: "\n\n")
        let result = NSMutableAttributedString()

        for (index, block) in components.enumerated() {
            if let attr = try? AttributedString(markdown: block, options: .init(interpretedSyntax: .full)) {
                var mutableAttr = NSMutableAttributedString(attributedString: NSAttributedString(attr))
                mutableAttr.addAttributes([
                    .font: font,
                    .foregroundColor: textColor
                ], range: NSRange(location: 0, length: mutableAttr.length))

                result.append(mutableAttr)
            } else {
                result.append(NSAttributedString(string: block))
            }

            // 문단 줄바꿈
            if index < components.count - 1 {
                result.append(NSAttributedString(string: "\n\n"))
            }
        }

        return result
    }
}
