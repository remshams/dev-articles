//
//  AddReadingListItemFromArticleUseCase.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Foundation
import Combine

struct AppAddReadingListItemFromArticleUseCase {
  let addReadingListItem: AddReadingListItem
  let article: Article
}

extension AppAddReadingListItemFromArticleUseCase: AddReadingListItemFromArticleUseCase {
  typealias Success = ReadingListItem
  typealias Failure = RepositoryError
  
  func start() -> AnyPublisher<Success, Failure> {
    addReadingListItem.addFrom(article: article)
  }
}
