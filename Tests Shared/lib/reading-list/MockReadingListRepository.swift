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
    return Just(ReadingListItem.init(from: article, savedAt: Date())).setFailureType(to: DbError.self).eraseToAnyPublisher()
  }
}


protocol FailingAddReadingListItem: AddReadingListItem {
  
}

extension FailingAddReadingListItem {
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, DbError> {
    return Fail<ReadingListItem, DbError>(error: DbError.error).eraseToAnyPublisher()
  }
}


