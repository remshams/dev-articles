//
//  ReadingListRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Foundation
import Combine

protocol AddReadingListItem {
  func addFrom(article: Article) -> AnyPublisher<ReadingListItem, DbError>
}

protocol ListReadingListItem {
  func list() -> AnyPublisher<[ReadingListItem], DbError>
  func list(for articleIds: [ArticleId]) -> AnyPublisher<[ReadingListItem], DbError>
}
