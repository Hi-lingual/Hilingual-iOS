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
    
    private var date: String = ""
    private var originalText: String = ""
    private var highlightText: String = ""
    private var diffRanges: [DiffRange] = []
    private var image: UIImage?
    private var isHighlightingEnabled: Bool = true
    
    
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
        return textView
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.cap_r_12)
        label.textColor = .gray400
        return label
    }()
    
    // MARK: - Custom Method
    
    override func setUI() {
        addSubviews(diaryImageView, textView, textCountLabel)
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        diaryImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        diaryImageView.addGestureRecognizer(tapGesture)
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
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(image: String?, originalText: String, highlightText: String, diffRanges: [DiffRange], isHighlightingEnabled: Bool) {
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
    
    @objc private func handleTapGesture() {
        guard let image = diaryImageView.image else { return }

        let detailImageView = DetailImageView(image: image)
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            detailImageView.frame = window.bounds
            window.addSubview(detailImageView)
        }
    }
}
