//
//  UIView+.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let vc = responder as? UIViewController {
                return vc
            }
            parentResponder = responder.next
        }
        return nil
    }
}
