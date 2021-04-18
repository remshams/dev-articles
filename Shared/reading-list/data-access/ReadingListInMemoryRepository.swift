//
//  ReadingListInMemoryRepository.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation
import Combine

class ReadingListInMemoryRepository: InMemoryRepository<ReadingListItem>, ListReadingListItem, AddReadingListItem {
  
  init(readingListItemsById : [ReadingListItem.ID: ReadingListItem]) {
    super.init(entitiesById: readingListItemsById)
  }
  
  convenience init(readingListItems: [ReadingListItem]) {
    self.init(readingListItemsById: readingListItems.toDictionaryById())
  }
  
  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], RepositoryError> {
    listBy(keyPath: \ReadingListItem.contentId, ids: articleIds)
  }
  
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, RepositoryError> {
    add(entity: ReadingListItem.init(from: article, savedAt: Date()))
  }
  
}
