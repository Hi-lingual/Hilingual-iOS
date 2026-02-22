//
//  Chip.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/6/25.
//

import UIKit
import SnapKit

enum ChipSize {
    case small
    case large

    var font: UIFont {
        switch self {
        case .small: return .pretendard(.cap_r_12)
        case .large: return .pretendard(.body_sb_14)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return 10
        case .large: return 16
        }
    }

    var imageSize: CGFloat {
        switch self {
        case .small: return 24
        case .large: return 36
        }
    }

    var verticalInset: CGFloat {
        switch self {
        case .small: return 2.5
        case .large: return 6
        }
    }

    var horizontalInset: CGFloat {
        switch self {
        case .small: return 6
        case .large: return 12
        }
    }
}

enum ChipType {
    case me
    case ai
    case verb
    case noun
    case pronoun
    case adjective
    case adverb
    case preposition
    case conjunction
    case interjection
    case phrase
    case clause
    case expression

    var isImageChip: Bool {
        self == .me || self == .ai
    }
    
    var image: UIImage? {
        switch self {
        case .me:
            return UIImage(named: "meChip", in: .module, compatibleWith: nil)
        case .ai:
            return UIImage(named: "aiChip", in: .module, compatibleWith: nil)
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .verb: return "동사"
        case .noun: return "명사"
        case .pronoun: return "대명사"
        case .adjective: return "형용사"
        case .adverb: return "부사"
        case .preposition: return "전치사"
        case .conjunction: return "접속사"
        case .interjection: return "감탄사"
        case .phrase: return "숙어"
        case .clause: return "속어"
        case .expression: return "구"
        case .me, .ai: return ""
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .verb: return .hilingualOrange
        case .noun: return .noun_bg
        case .pronoun: return .pronoun_bg
        case .adjective: return .adj_bg
        case .adverb: return .adverb_bg
        case .preposition: return .preposition_bg
        case .conjunction: return .hilingualBlue
        case .interjection: return .interjection_bg
        case .phrase, .clause, .expression: return .gray100
        case .me, .ai: return .clear
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .noun: return .hilingualBlue
        case .pronoun: return .pronoun_text
        case .adjective: return .adj_text
        case .adverb: return .adverb_text
        case .preposition: return .preposition_text
        case .phrase, .clause, .expression: return .gray400
        default:
            return .white
        }
    }
}

final class Chip: UIView {

    // MARK: - Properties

    private let label = UILabel()
    private let imageView = UIImageView()

    // MARK: - Lifecycle

    init(type: ChipType, size: ChipSize = .small) {
        super.init(frame: .zero)

        setUI(type: type)
        setStyle(type: type, size: size)
        setLayout(type: type, size: size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setStyle(type: ChipType, size: ChipSize) {
        backgroundColor = type.backgroundColor
        layer.cornerRadius = size.cornerRadius
        clipsToBounds = true

        if type.isImageChip {
            imageView.image = type.image
            imageView.contentMode = .scaleAspectFit
        } else {
            label.text = type.title
            label.textColor = type.textColor
            label.font = size.font
            label.textAlignment = .center
            label.numberOfLines = 1
        }
    }

    private func setUI(type: ChipType) {
        if type.isImageChip {
            addSubview(imageView)
        } else {
            addSubview(label)
        }
    }

    private func setLayout(type: ChipType, size: ChipSize) {
        if type.isImageChip {
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.size.equalTo(size.imageSize)
            }
        } else {
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.verticalEdges.equalToSuperview().inset(size.verticalInset)
                $0.horizontalEdges.equalToSuperview().inset(size.horizontalInset)
            }
        }
    }
}

fileprivate final class ChipPreviewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chip1 = Chip(type: .me)
        let chip2 = Chip(type: .noun)
        
        view.addSubviews(chip1, chip2)
        
        chip1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(view.snp.centerX).offset(-4)
        }
        
        chip2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(view.snp.centerX).offset(4)
        }
    }
}

#Preview {
    ChipPreviewViewController()
}
