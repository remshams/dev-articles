//
//  MockReadingListRepository.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 05.04.21.
//

import Foundation
import Combine
@testable import dev_articles

protocol InMemoryAddReadingListItem: AddReadingListItem {
}

extension InMemoryAddReadingListItem {
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, DbError> {
    Just(ReadingListItem.init(from: article, savedAt: Date())).setFailureType(to: DbError.self).eraseToAnyPublisher()
  }
}


protocol FailingAddReadingListItem: AddReadingListItem {
  
}

extension FailingAddReadingListItem {
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, DbError> {
    Fail<ReadingListItem, DbError>(error: DbError.error).eraseToAnyPublisher()
  }
}

protocol InMemoryListReadingListItem: ListReadingListItem {
  var readingListItems: [ReadingListItem] { get }
}

extension InMemoryListReadingListItem {
  func list() -> AnyPublisher<[ReadingListItem], DbError> {
    Just(readingListItems).setFailureType(to: DbError.self).eraseToAnyPublisher()
  }
  
  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], DbError> {
    Just(readingListItems)
      .map { readingListItems in
        readingListItems.filter { articleIds.contains($0.articleId) }
      }
      .setFailureType(to: DbError.self)
      .eraseToAnyPublisher()
  }
  
}

protocol FailingListReadingListItem: ListReadingListItem {}

extension FailingAddReadingListItem {
  func list() -> AnyPublisher<[ReadingListItem], DbError> {
    Fail<[ReadingListItem], DbError>(error: DbError.error).eraseToAnyPublisher()
  }
  
  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], DbError> {
    Fail<[ReadingListItem], DbError>(error: DbError.error).eraseToAnyPublisher()
  }
}
