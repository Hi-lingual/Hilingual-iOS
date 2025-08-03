import UIKit
import SnapKit

final class CustomCalendarCell: UICollectionViewCell {

    // MARK: - UI Components

    private let bubbleView = UIImageView()
    private let dayLabel = UILabel()
    private let dotView = UIView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        contentView.addSubview(bubbleView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(dotView)

        dayLabel.font = .suit(.body_sb_14)
        dayLabel.textColor = .black

        dotView.backgroundColor = .hilingualBlue
        dotView.layer.cornerRadius = 2
        dotView.isHidden = true
    }

    private func setupLayout() {
        bubbleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(34)
        }

        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        dotView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bubbleView.snp.bottom).offset(4)
            $0.size.equalTo(CGSize(width: 4, height: 4))
        }
    }

    // MARK: - Public

    func configure(
        day: Int,
        isToday: Bool,
        isSelected: Bool,
        isFilled: Bool,
        isWithinMonth: Bool
    ) {
        dayLabel.text = "\(day)"
        dayLabel.font = .suit(.body_sb_14)

        if isWithinMonth {
            dayLabel.textColor = .black
        } else {
            dayLabel.textColor = .gray200
        }

        if isSelected {
            bubbleView.image = UIImage(named: "img_bubble_filled_ios", in: .module, compatibleWith: nil)
            dayLabel.textColor = .white
        } else if isFilled {
            bubbleView.image = UIImage(named: "img_bubble_written_ios", in: .module, compatibleWith: nil)
            dayLabel.textColor = .hilingualBlue
        } else {
            bubbleView.image = nil
        }

        dotView.isHidden = !isToday
    }
}
