//
//  String+Markdown.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2025/09/17.
//

import UIKit

extension String {
    func toMarkdownAttributedString(
        font: UIFont = .pretendard(.body_r_16),
        textColor: UIColor = .gray850
    ) -> NSAttributedString {
        let paragraphs = components(separatedBy: "\n\n")
        let result = NSMutableAttributedString()

        for (index, paragraph) in paragraphs.enumerated() {
            let processedParagraph = escapeNumberedList(in: paragraph)
            let markdownParagraph = convertLineBreaks(in: processedParagraph)

            if let attributedString = parseMarkdown(markdownParagraph, font: font, textColor: textColor) {
                result.append(attributedString)
            } else {
                result.append(createPlainText(paragraph, font: font, textColor: textColor))
            }

            if index < paragraphs.count - 1 {
                result.append(NSAttributedString(string: "\n\n"))
            }
        }

        return result
    }

    private func escapeNumberedList(in text: String) -> String {
        let pattern = "^(\\d+)\\. "
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else {
            return text
        }

        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(
            in: text,
            options: [],
            range: range,
            withTemplate: "$1\\\\. "
        )
    }

    private func convertLineBreaks(in text: String) -> String {
        text.replacingOccurrences(of: "\n", with: "  \n")
    }

    private func parseMarkdown(
        _ text: String,
        font: UIFont,
        textColor: UIColor
    ) -> NSAttributedString? {
        guard let attributedString = try? AttributedString(
            markdown: text,
            options: .init(interpretedSyntax: .full)
        ) else {
            return nil
        }

        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(attributedString))
        let paragraphStyle = createParagraphStyle()

        mutableAttributedString.addAttributes(
            [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ],
            range: NSRange(location: 0, length: mutableAttributedString.length)
        )

        return mutableAttributedString
    }

    private func createParagraphStyle() -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        return style
    }

    private func createPlainText(
        _ text: String,
        font: UIFont,
        textColor: UIColor
    ) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: textColor
            ]
        )
    }
}
