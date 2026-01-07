//
//  UICollectionViewCell+.swift
//  HilingualPresentation
//
//  Created by 조영서 on 1/7/26.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
