//
//  SearchBar.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import UIKit
import SnapKit

public final class SearchBar: UISearchBar {

    // MARK: - Properties

    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Size
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 38)
    }

    // MARK: - Setup Methods
    
    private func setStyle() {
        self.searchBarStyle = .minimal
        self.searchTextField.backgroundColor = .white
        self.searchTextField.layer.cornerRadius = 8
        self.searchTextField.clipsToBounds = true
        self.setImage(UIImage(named: "ic_search_20_ios", in: .module, compatibleWith: nil), for: .search, state: .normal)
        self.setImage(UIImage(named: "ic_close_20_ios", in: .module, compatibleWith: nil), for: .clear, state: .normal)
        self.searchTextField.attributedText = .suit(.body_m_16, text: "")
        self.searchTextField.defaultTextAttributes[.font] = UIFont.suit(.body_m_16)
        self.searchTextField.keyboardType = .asciiCapable
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.autocapitalizationType = .none
    }

    private func updatePlaceholder() {
        guard let placeholderText = placeholder else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray400,
            .font: UIFont.suit(.body_m_16)
        ]
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: attributes
        )
    }
}
