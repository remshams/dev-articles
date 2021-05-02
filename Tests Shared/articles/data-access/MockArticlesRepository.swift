//
//  MockArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Foundation
import Combine
@testable import dev_articles




struct FailingListArticle: ListArticle {
  let listError: RepositoryError
  
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    Fail<[Article], RepositoryError>(error: listError).eraseToAnyPublisher()
  }
}

struct InMemoryListArticle: ListArticle {
  let articles: [Article]
  
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    Just(articles).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
