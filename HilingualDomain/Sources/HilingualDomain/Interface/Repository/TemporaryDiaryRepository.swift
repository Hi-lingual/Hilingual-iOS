//
//  TemporaryDiaryRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 11/13/25.
//

import Combine
import Foundation

public protocol TemporaryDiaryRepository {
    func save(_ draft: TemporaryDiaryEntity) -> AnyPublisher<Void, Error>
    func fetchAll() -> AnyPublisher<[TemporaryDiaryEntity], Error>
    func fetch(by date: Date) -> AnyPublisher<TemporaryDiaryEntity?, Error>
    func delete(id: String) -> AnyPublisher<Void, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
}
