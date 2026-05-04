//
//  UIStackView+.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/7/25.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
