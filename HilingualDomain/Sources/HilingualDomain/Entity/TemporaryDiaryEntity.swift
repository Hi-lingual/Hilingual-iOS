//
//  TemporaryDiaryEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 11/13/25.
//

import Foundation
import UIKit

public struct TemporaryDiaryEntity: Identifiable, Equatable {
    public let id: String
    public let text: String
    public let date: Date
    public let image: Data?

    public init(
        id: String = UUID().uuidString,
        text: String,
        date: Date,
        image: Data? = nil
    ) {
        self.id = id
        self.text = text
        self.date = date
        self.image = image
    }
}
