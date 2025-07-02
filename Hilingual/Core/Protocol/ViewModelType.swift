//
//  ViewModelType.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
