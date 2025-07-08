import UIKit
import SnapKit

struct PhraseData {
    let phraseId: Int
    let phraseType: [String]
    let phrase: String
    let explanation: String
    let example: String?
    let isMarked: Bool
    let created_at: String?
}

enum WordCardType {
    case basic
    case withExample
    case withDate
}

final class WordCard: UIView {
    
    // MARK: - UI Components
    
    private let chipStackView = UIStackView()
    private let phraseLabel = UILabel()
    private let explanationLabel = UILabel()
    private let savedDateLabel = UILabel()
    private let exampleLabel = UILabel()
    private let bookmarkButton = UIButton(type: .custom)
    
    // MARK: - State
    
    private var isMarked: Bool = false
    var onBookmarkToggled: ((Bool) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(type: WordCardType, data: PhraseData) {
        isMarked = data.isMarked
        
        chipStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        data.phraseType.compactMap { chipType(from: $0) }
            .map { Chip(type: $0) }
            .forEach { chipStackView.addArrangedSubview($0) }
        
        phraseLabel.text = data.phrase
        explanationLabel.text = data.explanation
        updateBookmarkImage()
        
        explanationLabel.isHidden = false
        exampleLabel.isHidden = false
        savedDateLabel.isHidden = false
        
        phraseLabel.snp.removeConstraints()
        explanationLabel.snp.removeConstraints()
        exampleLabel.snp.removeConstraints()
        savedDateLabel.snp.removeConstraints()
        
        switch type {
        case .basic:
            phraseLabel.font = .suit(.head_m_18)
            explanationLabel.isHidden = true
            exampleLabel.isHidden = true
            savedDateLabel.isHidden = true
            
            phraseLabel.snp.makeConstraints {
                $0.top.equalTo(chipStackView.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview().inset(12)
                $0.bottom.equalToSuperview().inset(12)
            }
            
        case .withExample:
            phraseLabel.font = .suit(.body_sb_16)
            explanationLabel.font = .suit(.body_b_14)
            
            exampleLabel.isHidden = data.example == nil
            exampleLabel.text = data.example.map { "\"\($0)\"" }
            savedDateLabel.isHidden = true
            
            phraseLabel.snp.makeConstraints {
                $0.top.equalTo(chipStackView.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview().inset(12)
            }
            explanationLabel.snp.makeConstraints {
                $0.top.equalTo(phraseLabel.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview().inset(12)
            }
            
            if data.example == nil {
                explanationLabel.snp.makeConstraints {
                    $0.bottom.equalToSuperview().inset(12)
                }
            } else {
                exampleLabel.snp.makeConstraints {
                    $0.top.equalTo(explanationLabel.snp.bottom).offset(8)
                    $0.leading.trailing.equalToSuperview().inset(12)
                    $0.bottom.equalToSuperview().inset(12)
                }
            }
            
        case .withDate:
            phraseLabel.font = .suit(.body_m_20)
            explanationLabel.font = .suit(.body_m_14)
            
            exampleLabel.isHidden = true
            savedDateLabel.text = formattedCreatedDate(data.created_at)
            
            chipStackView.snp.updateConstraints {
                $0.top.leading.equalToSuperview().inset(24)
            }
            bookmarkButton.snp.updateConstraints {
                $0.top.trailing.equalToSuperview().inset(24)
            }
            
            phraseLabel.snp.makeConstraints {
                $0.top.equalTo(chipStackView.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview().inset(24)
            }
            explanationLabel.snp.makeConstraints {
                $0.top.equalTo(phraseLabel.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview().inset(24)
            }
            savedDateLabel.snp.makeConstraints {
                $0.top.equalTo(explanationLabel.snp.bottom).offset(8)
                $0.trailing.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(40)
            }
        }
    }
    
    // MARK: - Layout
    
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        
        chipStackView.axis = .horizontal
        chipStackView.spacing = 4
        
        explanationLabel.numberOfLines = 0
        exampleLabel.numberOfLines = 0
        exampleLabel.font = .suit(.caption_m_12)
        exampleLabel.textColor = .gray700
        savedDateLabel.font = .suit(.caption_m_12)
        savedDateLabel.textColor = .gray400
        
        bookmarkButton.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
        
        addSubviews(chipStackView, phraseLabel, explanationLabel, savedDateLabel, exampleLabel, bookmarkButton)
    }
    
    private func setLayout() {
        chipStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
        }
        bookmarkButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Helpers
    
    @objc private func didTapBookmark() {
        isMarked.toggle()
        updateBookmarkImage()
        onBookmarkToggled?(isMarked)
    }
    
    private func updateBookmarkImage() {
        let imageName = isMarked ? "ic_save_variant_28_ios" : "ic_save_default_28_ios"
        bookmarkButton.setImage(UIImage(named: imageName, in: .module, compatibleWith: nil), for: .normal)
    }
    
    private func chipType(from korTitle: String) -> ChipType? {
        switch korTitle {
        case "동사": return .verb
        case "명사": return .noun
        case "대명사": return .pronoun
        case "형용사": return .adjective
        case "부사": return .adverb
        case "전치사": return .preposition
        case "접속사": return .conjunction
        case "감탄사": return .interjection
        case "숙어": return .phrase
        case "속어": return .clause
        case "구": return .expression
        case "me": return .me
        case "AI": return .ai
        default: return nil
        }
    }
    
    private func formattedCreatedDate(_ createdAt: String?) -> String {
        guard let date = createdAt else { return "" }
        let trimmed = String(date.dropFirst(2))
        return "\(trimmed) 일기에서 저장됨"
    }
}
