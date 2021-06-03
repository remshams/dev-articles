//
//  ReadingListUseCase.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Combine
@testable import dev_articles
import Foundation

struct MockAddReadingListItemFromArticleUseCase: AddReadingListItemFromArticleUseCase {
  let readingListItem: ReadingListItem

  init(readingListItem: ReadingListItem = ReadingListItem(from: Article.createFixture(), savedAt: Date())) {
    self.readingListItem = readingListItem
  }

  func start() -> AnyPublisher<ReadingListItem, RepositoryError> {
    Just(readingListItem).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
