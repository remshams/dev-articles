//
//  MockArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Foundation
import Combine
@testable import dev_articles


extension ListArticle {
  func list$() -> AnyPublisher<[Article], RestError> {
    Just([]).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
}

protocol FailingListArticle: ListArticle {
  var listError: RestError { get }
}

extension FailingListArticle {
  func list$() -> AnyPublisher<[Article], RestError> {
    Fail<[Article], RestError>(error: listError).eraseToAnyPublisher()
  }
}

protocol InMemoryListArticle: ListArticle {
  var articles: [Article] { get }
}

extension InMemoryListArticle {
  func list$() -> AnyPublisher<[Article], RestError> {
    Just(articles).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
}
