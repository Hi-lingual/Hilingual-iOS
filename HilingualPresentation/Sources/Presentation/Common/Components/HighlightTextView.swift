//
//  HighlightTextView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/6/25.
//

import UIKit

import Kingfisher
import SnapKit

final class HighlightTextView: BaseUIView {
    
    // MARK: - UI Properties
    
    struct DiffRange {
        let start: Int
        let end: Int
    }
    
    private var originalText: String = ""
    private var highlightText: String = ""
    private var diffRanges: [DiffRange] = []
    private var isHighlightingEnabled: Bool = true
    private var readingStartLocation: Int?
    
    
    // MARK: - UI Components
    
    let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .imgLoadFailLargeIos)
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.textColor = .hilingualBlack
        textView.layoutManager.usesFontLeading = false

        return textView
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.cap_r_12)
        label.textColor = .gray400
        return label
    }()

    private let speechButton = ListeningButton()

    // MARK: - Custom Method
    
    override func setUI() {
        addSubviews(diaryImageView, textView, speechButton, textCountLabel)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.layoutManager.usesFontLeading = false
        speechButton.addTarget(self, action: #selector(didTapSpeechButton), for: .touchUpInside)
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:))))

        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        diaryImageView.isUserInteractionEnabled = true
        diaryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    override func setLayout() {
        diaryImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(diaryImageView.snp.width).multipliedBy(0.6)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(diaryImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(speechButton)
        }

        speechButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(12)
            $0.width.equalTo(44)
            $0.height.equalTo(28)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(image: String?, originalText: String, highlightText: String, diffRanges: [DiffRange], isHighlightingEnabled: Bool) {
        if EnglishPronunciationPlayer.shared.isSpeaking {
            EnglishPronunciationPlayer.shared.stop()
        }
        speechButton.updateState(isListening: false)

        if let image = image, !image.isEmpty, let url = URL(string: image) {
            diaryImageView.kf.setImage(with: url)
            diaryImageView.isHidden = false
        } else {
            diaryImageView.isHidden = true
            diaryImageView.snp.makeConstraints {
                $0.height.equalTo(0)
            }
            textView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
            }
        }
        
        self.originalText = originalText
        self.highlightText = highlightText
        self.diffRanges = diffRanges
        self.isHighlightingEnabled = isHighlightingEnabled
        speechButton.isHidden = highlightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        toggleText()
    }
    
    func highlightCorrections(textType: String, diffRanges: [DiffRange]) {
        let attributed = NSMutableAttributedString(attributedString: .pretendard(.body_r_15, text: textType, lineBreakMode: .byWordWrapping))
        attributed.addAttribute(.foregroundColor, value: UIColor.hilingualBlack, range: NSRange(location: 0, length: attributed.length))
        
        for range in diffRanges {
            let nsRange = NSRange(location: range.start, length: range.end - range.start)
            attributed.addAttributes([.font: UIFont.pretendard(.body_m_15),
                                      .foregroundColor: UIColor.hilingualOrange],
                                     range: nsRange)
        }
        
        textView.attributedText = attributed
    }
    
    func toggleText() {
        if isHighlightingEnabled {
            highlightCorrections(textType: highlightText, diffRanges: diffRanges)
            textCountLabel.text = "\(highlightText.count)/1500"
        } else {
            let attr = NSMutableAttributedString(attributedString: .pretendard(.body_r_15, text: originalText, lineBreakMode: .byWordWrapping, forceWrap: true))
            attr.addAttribute(.foregroundColor, value: UIColor.hilingualBlack, range: NSRange(location: 0, length: attr.length))
            textView.attributedText = attr
            textCountLabel.text = "\(originalText.count)/1000"
        }
        isHighlightingEnabled.toggle()
    }
}

// MARK: - Private Methods

private extension HighlightTextView {
    var displayedText: String {
        textView.attributedText?.string ?? ""
    }

    // MARK: - Speech

    func resetReadingHighlight() {
        readingStartLocation = nil
        speechButton.updateState(isListening: false)

        if displayedText == highlightText {
            highlightCorrections(textType: highlightText, diffRanges: diffRanges)
        } else {
            let attr = NSMutableAttributedString(attributedString: .pretendard(.body_r_15, text: originalText, lineBreakMode: .byWordWrapping, forceWrap: true))
            attr.addAttribute(.foregroundColor, value: UIColor.hilingualBlack, range: NSRange(location: 0, length: attr.length))
            textView.attributedText = attr
        }
    }

    @objc func didTapSpeechButton() {
        if EnglishPronunciationPlayer.shared.isSpeaking {
            EnglishPronunciationPlayer.shared.stop()
            resetReadingHighlight()
            return
        }

        startReading(from: 0)
    }

    func startReading(from location: Int) {
        let nsText = highlightText as NSString
        guard !highlightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        if EnglishPronunciationPlayer.shared.isSpeaking {
            EnglishPronunciationPlayer.shared.stop()
        }

        var startLocation = min(max(location, 0), nsText.length)
        while startLocation < nsText.length {
            let current = nsText.substring(with: NSRange(location: startLocation, length: 1))
            if current.rangeOfCharacter(from: .whitespacesAndNewlines) == nil { break }
            startLocation += 1
        }

        let text = nsText.substring(from: startLocation)
        guard !text.isEmpty else { return }

        readingStartLocation = startLocation
        speechButton.updateState(isListening: true)
        renderReadingHighlight(upTo: startLocation)

        EnglishPronunciationPlayer.shared.speak(
            text,
            stateChanged: { [weak self] isSpeaking in
                self?.speechButton.updateState(isListening: isSpeaking)
            },
            willSpeakRange: { [weak self] characterRange in
                guard let self, let start = self.readingStartLocation else { return }
                self.renderReadingHighlight(upTo: start + NSMaxRange(characterRange))
            },
            didFinish: { [weak self] in
                guard let self else { return }
                self.renderReadingHighlight(upTo: (self.displayedText as NSString).length)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    guard let self, !EnglishPronunciationPlayer.shared.isSpeaking else { return }
                    self.resetReadingHighlight()
                }
            },
            didCancel: { [weak self] in
                guard let self else { return }
                self.resetReadingHighlight()
            }
        )
    }

    // MARK: - Reading Highlight

    func renderReadingHighlight(upTo location: Int) {
        let text = displayedText
        let attributed = NSMutableAttributedString(attributedString: .pretendard(.body_r_15, text: text, lineBreakMode: .byWordWrapping))
        attributed.addAttribute(.foregroundColor, value: UIColor.gray400, range: NSRange(location: 0, length: attributed.length))

        if text == highlightText {
            diffRanges.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                guard NSMaxRange(range) <= attributed.length else { return }
                attributed.addAttributes([
                    .font: UIFont.pretendard(.body_m_15),
                    .foregroundColor: UIColor.hilingualOrange.withAlphaComponent(0.55)
                ], range: range)
            }
        }

        let progressLocation = min(max(location, 0), attributed.length)
        let startLocation = min(max(readingStartLocation ?? 0, 0), progressLocation)
        guard progressLocation > startLocation else {
            textView.attributedText = attributed
            return
        }

        let readRange = NSRange(location: startLocation, length: progressLocation - startLocation)
        attributed.addAttribute(.foregroundColor, value: UIColor.hilingualBlack, range: readRange)

        if text == highlightText {
            diffRanges.forEach {
                let correctionRange = NSRange(location: $0.start, length: $0.end - $0.start)
                let range = NSIntersectionRange(readRange, correctionRange)
                guard range.length > 0, NSMaxRange(range) <= attributed.length else { return }
                attributed.addAttributes([
                    .font: UIFont.pretendard(.body_m_15),
                    .foregroundColor: UIColor.hilingualOrange
                ], range: range)
            }
        }

        textView.attributedText = attributed
    }

    // MARK: - Text Selection

    @objc func didTapTextView(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended,
              !highlightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let location = gesture.location(in: textView)
        guard let sentenceStartLocation = sentenceStartLocation(at: location) else { return }

        startReading(from: sentenceStartLocation)
    }

    func sentenceStartLocation(at point: CGPoint) -> Int? {
        textView.layoutManager.ensureLayout(for: textView.textContainer)

        let textContainer = textView.textContainer
        let usedRect = textView.layoutManager.usedRect(for: textContainer)
        let offset = CGPoint(
            x: (textView.bounds.width - usedRect.width) * 0.5 - usedRect.origin.x,
            y: (textView.bounds.height - usedRect.height) * 0.5 - usedRect.origin.y
        )
        let containerPoint = CGPoint(
            x: point.x - offset.x - textView.textContainerInset.left,
            y: point.y - offset.y - textView.textContainerInset.top
        )

        let index = textView.layoutManager.characterIndex(
            for: containerPoint,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        let nsText = highlightText as NSString
        guard index < nsText.length else { return nil }

        let previousPeriodRange = nsText.range(
            of: ".",
            options: .backwards,
            range: NSRange(location: 0, length: index)
        )
        let nextPeriodRange = nsText.range(
            of: ".",
            range: NSRange(location: index, length: nsText.length - index)
        )

        let sentenceStart = previousPeriodRange.location == NSNotFound ? 0 : NSMaxRange(previousPeriodRange)
        let sentenceEnd = nextPeriodRange.location == NSNotFound ? nsText.length : NSMaxRange(nextPeriodRange)
        let sentence = nsText.substring(with: NSRange(location: sentenceStart, length: sentenceEnd - sentenceStart))
        let leadingWhitespaceCount = sentence.prefix { $0.isWhitespace }.count

        let start = sentenceStart + leadingWhitespaceCount
        return start < sentenceEnd ? start : nil
    }
    
    @objc func handleTapGesture() {
        guard let image = diaryImageView.image else { return }

        let detailImageView = DetailImageView(image: image)
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            detailImageView.frame = window.bounds
            window.addSubview(detailImageView)
        }
    }
}
