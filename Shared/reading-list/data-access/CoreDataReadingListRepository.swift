//
//  ReadingListRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Combine
import CoreData
import Foundation

class CoreDataReadingListRepository: AddReadingListItem, ListReadingListItem {
  private let managedObjectContext: NSManagedObjectContext

  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }

  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, RepositoryError> {
    Just(article)
      .tryMap { article in
        let readingListItem = ReadingListItem(
          context: managedObjectContext,
          from: article,
          savedAt: Date()
        )
        try managedObjectContext.save()
        return readingListItem
      }
      .mapError { _ in
        RepositoryError.error
      }
      .eraseToAnyPublisher()
  }

  func list() -> AnyPublisher<[ReadingListItem], RepositoryError> {
    return Just(ReadingListItem.fetchRequest())
      .tryMap { fetchRequest in
        try managedObjectContext.fetch(fetchRequest)
      }
      .mapError { _ in RepositoryError.error }
      .eraseToAnyPublisher()
  }

  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], RepositoryError> {
    Just(ReadingListItem
      .fetchRequest(predicate: NSPredicate(format: "contentId IN %@", articleIds.map { String($0) })))
      .tryMap { fetchRequest in
        try managedObjectContext.fetch(fetchRequest)
      }
      .mapError { _ in RepositoryError.error }
      .eraseToAnyPublisher()
  }

  func clear() -> AnyPublisher<Void, RepositoryError> {
    Just(ReadingListItem.fetchRequest())
      .tryMap { fetchRequest in
        try managedObjectContext.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
      }
      .mapError { _ in RepositoryError.error }
      .eraseToAnyPublisher()
  }
}
