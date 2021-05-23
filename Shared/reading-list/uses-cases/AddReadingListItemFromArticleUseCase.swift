//
//  AddReadingListItemFromArticleUseCase.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Foundation
import Combine

struct AddReadingListItemFromArticleUseCase {
  let addReadingListItem: AddReadingListItem
  let article: Article
}

extension AddReadingListItemFromArticleUseCase: UseCase {
  typealias Success = ReadingListItem
  typealias Failure = RepositoryError
  
  func start() -> AnyPublisher<Success, Failure> {
    addReadingListItem.addFrom(article: article)
  }
}
