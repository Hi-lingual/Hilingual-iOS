//
//  SearchBar.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import UIKit
import SnapKit

public final class SearchBar: UISearchBar {

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    
    private func setStyle() {
        self.searchBarStyle = .minimal
        self.searchTextField.backgroundColor = .gray100
        self.searchTextField.layer.cornerRadius = 8
        self.searchTextField.clipsToBounds = true
        self.setImage(UIImage(named: "ic_search_20_ios", in: .module, compatibleWith: nil), for: .search, state: .normal)
        self.setImage(UIImage(named: "ic_close_20_ios", in: .module, compatibleWith: nil), for: .clear, state: .normal)
        self.searchTextField.attributedText = .pretendard(.body_m_16, text: "")
        self.searchTextField.defaultTextAttributes[.font] = UIFont.pretendard(.body_r_16)
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.autocapitalizationType = .none
        self.searchTextField.returnKeyType = .done
        self.searchTextField.placeholder = "닉네임을 입력해주세요."
    }

    private func updatePlaceholder() {
        guard let placeholderText = placeholder else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray400,
            .font: UIFont.pretendard(.body_r_16)
        ]
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: attributes
        )
    }
}
