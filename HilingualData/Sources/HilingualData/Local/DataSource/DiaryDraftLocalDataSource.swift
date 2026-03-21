//
//  DiaryDraftLocalDataSource.swift
//  HilingualData
//
//  Created by 진소은 on 11/13/25.
//

import Foundation
import CoreData

import Combine
import HilingualCore
import HilingualDomain

public protocol DiaryDraftLocalDataSource {
    func save(_ draft: TemporaryDiaryEntity) -> AnyPublisher<Void, Error>
    func fetchAll() -> AnyPublisher<[TemporaryDiaryEntity], Error>
    func fetch(by date: Date) -> AnyPublisher<TemporaryDiaryEntity?, Error>
    func delete(by id: String) -> AnyPublisher<Void, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
}

public final class DefaultDiaryDraftLocalDataSource: DiaryDraftLocalDataSource {
    private let viewContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext

    public init(viewContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.backgroundContext = backgroundContext
    }
    
    public func save(_ draft: TemporaryDiaryEntity) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }

            self.backgroundContext.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryDraft")

                    let calendar = AppTimeZone.calendar
                    let start = calendar.startOfDay(for: draft.date)
                    let end = calendar.date(byAdding: .day, value: 1, to: start)!

                    request.predicate = NSPredicate(
                        format: "date >= %@ AND date < %@", start as NSDate, end as NSDate
                    )

                    let results = try self.backgroundContext.fetch(request)

                    let object: NSManagedObject
                    if let existing = results.first {
                        object = existing
                    } else {
                        object = NSEntityDescription.insertNewObject(
                            forEntityName: "DiaryDraft",
                            into: self.backgroundContext
                        )
                    }

                    object.setValue(draft.id, forKey: "id")
                    object.setValue(draft.text, forKey: "text")
                    object.setValue(draft.date, forKey: "date")
                    object.setValue(draft.image, forKey: "image")

                    try self.backgroundContext.save()

                    self.viewContext.perform {
                        try? self.viewContext.save()
                    }

                    promise(.success(()))

                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func fetchAll() -> AnyPublisher<[TemporaryDiaryEntity], Error> {
        Future { [weak self] promise in
            guard let self else { return }
            self.viewContext.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryDraft")
                    let results = try self.viewContext.fetch(request)
                    let entities = results.map {
                        TemporaryDiaryEntity(
                            id: $0.value(forKey: "id") as? String ?? UUID().uuidString,
                            text: $0.value(forKey: "text") as? String ?? "",
                            date: $0.value(forKey: "date") as? Date ?? Date(),
                            image: $0.value(forKey: "image") as? Data
                        )
                    }
                    promise(.success(entities))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func fetch(by date: Date) -> AnyPublisher<TemporaryDiaryEntity?, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            self.viewContext.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryDraft")

                    let calendar = AppTimeZone.calendar
                    let start = calendar.startOfDay(for: date)
                    let end = calendar.date(byAdding: .day, value: 1, to: start)!

                    request.predicate = NSPredicate(
                        format: "date >= %@ AND date < %@", start as NSDate, end as NSDate
                    )

                    request.sortDescriptors = [
                        NSSortDescriptor(key: "date", ascending: false)
                    ]

                    request.fetchLimit = 1

                    let results = try self.viewContext.fetch(request)
                    let entity = results.first.map {
                        TemporaryDiaryEntity(
                            id: $0.value(forKey: "id") as? String ?? UUID().uuidString,
                            text: $0.value(forKey: "text") as? String ?? "",
                            date: $0.value(forKey: "date") as? Date ?? Date(),
                            image: $0.value(forKey: "image") as? Data
                        )
                    }
                    promise(.success(entity))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func delete(by id: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            self.viewContext.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: "DiaryDraft")
                    request.predicate = NSPredicate(format: "id == %@", id)
                    let results = try self.viewContext.fetch(request)
                    results.forEach { self.viewContext.delete($0) }
                    try self.viewContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func deleteAll() -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            self.viewContext.perform {
                do {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DiaryDraft")
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                    try self.viewContext.execute(deleteRequest)
                    try self.viewContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
