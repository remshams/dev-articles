//
//  MockArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Foundation
import Combine
@testable import dev_articles

struct InMemoryArticlesRepository: ArticlesRepository {
  let articles: [Article];
  
  init(articles: [Article] = []) {
    self.articles = articles
  }
  
  func list$() -> AnyPublisher<[Article], RestError> {
    Just(articles).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
  
}

extension ArticlesRepository {
  func list$() -> AnyPublisher<[Article], RestError> {
    Just([]).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
  
}

struct FailingArticlesRepository: ArticlesRepository {
  let error: RestError
  
  init(error: RestError = RestError.serverError) {
    self.error = error
  }
  
  func list$() -> AnyPublisher<[Article], RestError> {
    Fail<[Article], RestError>(error: error).eraseToAnyPublisher()
  }
}
