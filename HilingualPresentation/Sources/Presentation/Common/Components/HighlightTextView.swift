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
    private var currentHighlightPosition: Int = 0
    private var targetHighlightPosition: Int = 0
    private var highlightTimer: Timer?
    private var hasPlayedSpeech: Bool = false
    var onSpeechButtonTapped: ((Bool) -> Void)?
    
    
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
        
        speechButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.width.equalTo(44)
            $0.height.equalTo(28)
            $0.bottom.equalToSuperview().inset(12)
        }

        textCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(speechButton)
        }
    }
    
    func configure(image: String?, originalText: String, highlightText: String, diffRanges: [DiffRange], isHighlightingEnabled: Bool) {
        EnglishPronunciationPlayer.shared.prepare()

        if EnglishPronunciationPlayer.shared.isSpeaking {
            EnglishPronunciationPlayer.shared.stop()
        }
        speechButton.updateState(isListening: false)
        hasPlayedSpeech = false

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
        let attributedString = makeBaseAttributedText(textType, color: .hilingualBlack)
        applyDiffHighlights(to: attributedString, color: .hilingualOrange)
        textView.attributedText = attributedString
    }
    
    func stopSpeech() {
        EnglishPronunciationPlayer.shared.stop()
        resetReadingHighlight()
    }

    func toggleText() {
        if isHighlightingEnabled {
            highlightCorrections(textType: highlightText, diffRanges: diffRanges)
            textCountLabel.text = "\(highlightText.count)/1500"
            let showButton = !highlightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            updateSpeechButtonVisibility(isVisible: showButton)
        } else {
            stopSpeech()
            textView.attributedText = makeBaseAttributedText(originalText, color: .hilingualBlack, forceWrap: true)
            textCountLabel.text = "\(originalText.count)/1000"
            updateSpeechButtonVisibility(isVisible: false)
        }
        isHighlightingEnabled.toggle()
    }

    private func updateSpeechButtonVisibility(isVisible: Bool) {
        speechButton.isHidden = !isVisible

        if isVisible {
            speechButton.snp.remakeConstraints {
                $0.top.equalTo(textView.snp.bottom).offset(12)
                $0.leading.equalToSuperview().inset(12)
                $0.width.equalTo(44)
                $0.height.equalTo(28)
                $0.bottom.equalToSuperview().inset(12)
            }
            textCountLabel.snp.remakeConstraints {
                $0.trailing.equalToSuperview().inset(12)
                $0.bottom.equalTo(speechButton)
            }
        } else {
            speechButton.snp.remakeConstraints {
                $0.top.equalTo(textView.snp.bottom)
                $0.leading.equalToSuperview().inset(12)
                $0.width.equalTo(0)
                $0.height.equalTo(0)
            }
            textCountLabel.snp.remakeConstraints {
                $0.top.equalTo(textView.snp.bottom).offset(12)
                $0.trailing.equalToSuperview().inset(12)
                $0.bottom.equalToSuperview().inset(12)
            }
        }
    }
}

// MARK: - Private Methods

private extension HighlightTextView {
    var displayedText: String {
        textView.attributedText?.string ?? ""
    }

    // MARK: - Attributed Text Helpers

    func makeBaseAttributedText(_ text: String, color: UIColor, forceWrap: Bool = false) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: .pretendard(.body_r_15, text: text, lineBreakMode: .byWordWrapping, forceWrap: forceWrap))
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }

    func applyDiffHighlights(to attributedString: NSMutableAttributedString, color: UIColor, in clampRange: NSRange? = nil) {
        for diffRange in diffRanges {
            var range = NSRange(location: diffRange.start, length: diffRange.end - diffRange.start)
            if let clampRange { range = NSIntersectionRange(clampRange, range) }
            guard range.length > 0, NSMaxRange(range) <= attributedString.length else { continue }
            attributedString.addAttributes([.font: UIFont.pretendard(.body_m_15), .foregroundColor: color], range: range)
        }
    }

    // MARK: - Speech

    func animateHighlight(to target: Int) {
        targetHighlightPosition = target
        guard highlightTimer == nil else { return }
        let timer = Timer(timeInterval: 0.055, repeats: true) { [weak self] _ in
            guard let self, self.currentHighlightPosition < self.targetHighlightPosition else { return }
            self.currentHighlightPosition += 1
            self.renderReadingHighlight(upTo: self.currentHighlightPosition)
        }
        highlightTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    func stopHighlightTimer() {
        highlightTimer?.invalidate()
        highlightTimer = nil
    }

    func resetReadingHighlight() {
        stopHighlightTimer()
        readingStartLocation = nil
        speechButton.updateState(isListening: false)

        if displayedText == highlightText {
            highlightCorrections(textType: highlightText, diffRanges: diffRanges)
        } else {
            textView.attributedText = makeBaseAttributedText(originalText, color: .hilingualBlack, forceWrap: true)
        }
    }

    @objc func didTapSpeechButton() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let isFirstPlay = !hasPlayedSpeech
        hasPlayedSpeech = true
        onSpeechButtonTapped?(isFirstPlay)

        let player = EnglishPronunciationPlayer.shared

        if player.isPaused {
            player.resume()
            speechButton.updateState(isListening: true)
            return
        }

        if player.isSpeaking {
            player.pause()
            stopHighlightTimer()
            speechButton.updateState(isListening: false)
            return
        }

        startReading(from: 0)
    }

    func firstNonWhitespaceLocation(from location: Int, in text: NSString) -> Int {
        var index = min(max(location, 0), text.length)
        while index < text.length {
            let char = text.substring(with: NSRange(location: index, length: 1))
            if char.rangeOfCharacter(from: .whitespacesAndNewlines) == nil { break }
            index += 1
        }
        return index
    }

    func startReading(from location: Int) {
        let nsText = highlightText as NSString
        guard !highlightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        if EnglishPronunciationPlayer.shared.isSpeaking {
            EnglishPronunciationPlayer.shared.stop()
        }

        let startLocation = firstNonWhitespaceLocation(from: location, in: nsText)
        let text = nsText.substring(from: startLocation)
        guard !text.isEmpty else { return }

        readingStartLocation = startLocation
        currentHighlightPosition = startLocation
        targetHighlightPosition = startLocation
        speechButton.updateState(isListening: true)
        renderReadingHighlight(upTo: startLocation)

        EnglishPronunciationPlayer.shared.speak(
            text,
            willSpeakRange: { [weak self] characterRange in
                guard let self, let start = self.readingStartLocation else { return }
                self.animateHighlight(to: start + NSMaxRange(characterRange))
            },
            didFinish: { [weak self] in
                guard let self else { return }
                self.stopHighlightTimer()
                self.renderReadingHighlight(upTo: (self.displayedText as NSString).length)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    guard let self, !EnglishPronunciationPlayer.shared.isSpeaking else { return }
                    self.resetReadingHighlight()
                }
            },
            didCancel: { [weak self] in
                self?.stopHighlightTimer()
                self?.resetReadingHighlight()
            }
        )
    }

    // MARK: - Reading Highlight

    func readRange(upTo location: Int, length: Int) -> NSRange? {
        let progressLocation = min(max(location, 0), length)
        let startLocation = min(max(readingStartLocation ?? 0, 0), progressLocation)
        guard progressLocation > startLocation else { return nil }
        return NSRange(location: startLocation, length: progressLocation - startLocation)
    }

    func renderReadingHighlight(upTo location: Int) {
        let text = displayedText
        let attributedString = makeBaseAttributedText(text, color: .gray400)
        let isHighlightText = (text == highlightText)

        if isHighlightText {
            applyDiffHighlights(to: attributedString, color: UIColor.hilingualOrange.withAlphaComponent(0.55))
        }

        guard let readRange = readRange(upTo: location, length: attributedString.length) else {
            textView.attributedText = attributedString
            return
        }

        attributedString.addAttribute(.foregroundColor, value: UIColor.hilingualBlack, range: readRange)

        if isHighlightText {
            applyDiffHighlights(to: attributedString, color: .hilingualOrange, in: readRange)
        }

        textView.attributedText = attributedString
    }

    // MARK: - Text Selection

    @objc func didTapTextView(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended,
              !isHighlightingEnabled,
              !highlightText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let location = gesture.location(in: textView)
        guard let sentenceStartLocation = sentenceStartLocation(at: location) else { return }
        startReading(from: sentenceStartLocation)
    }

    func sentenceStartLocation(at point: CGPoint) -> Int? {
        textView.layoutManager.ensureLayout(for: textView.textContainer)
        let index = textView.layoutManager.characterIndex(
            for: point, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil
        )

        let text = highlightText as NSString
        guard index < text.length else { return nil }

        var sentenceRange = NSRange(location: 0, length: 0)
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length), options: .bySentences) { _, range, _, stop in
            if NSLocationInRange(index, range) {
                sentenceRange = range
                stop.pointee = true
            }
        }

        let sentence = text.substring(with: sentenceRange)
        let start = sentenceRange.location + sentence.prefix(while: { $0.isWhitespace }).count
        return start < NSMaxRange(sentenceRange) ? start : nil
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
