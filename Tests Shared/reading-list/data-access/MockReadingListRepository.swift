//
//  MockReadingListRepository.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 05.04.21.
//

import Combine
@testable import dev_articles
import Foundation

protocol InMemoryAddReadingListItem: AddReadingListItem {}

extension InMemoryAddReadingListItem {
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, RepositoryError> {
    Just(ReadingListItem(from: article, savedAt: Date())).setFailureType(to: RepositoryError.self)
      .eraseToAnyPublisher()
  }
}

protocol FailingAddReadingListItem: AddReadingListItem {}

extension FailingAddReadingListItem {
  func addFrom(article _: Article) -> AnyPublisher<ReadingListItem, RepositoryError> {
    Fail<ReadingListItem, RepositoryError>(error: RepositoryError.error).eraseToAnyPublisher()
  }
}

protocol InMemoryListReadingListItem: ListReadingListItem {
  var readingListItems: [ReadingListItem] { get }
}

extension InMemoryListReadingListItem {
  func list() -> AnyPublisher<[ReadingListItem], RepositoryError> {
    Just(readingListItems).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }

  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], RepositoryError> {
    Just(readingListItems)
      .map { readingListItems in
        readingListItems.filter { articleIds.contains($0.contentId) }
      }
      .setFailureType(to: RepositoryError.self)
      .eraseToAnyPublisher()
  }
}

protocol FailingListReadingListItem: ListReadingListItem {}

extension FailingAddReadingListItem {
  func list() -> AnyPublisher<[ReadingListItem], RepositoryError> {
    Fail<[ReadingListItem], RepositoryError>(error: RepositoryError.error).eraseToAnyPublisher()
  }

  func list(for _: [ArticleId]) -> AnyPublisher<[ReadingListItem], RepositoryError> {
    Fail<[ReadingListItem], RepositoryError>(error: RepositoryError.error).eraseToAnyPublisher()
  }
}
