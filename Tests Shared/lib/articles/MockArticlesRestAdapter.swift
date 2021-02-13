//
//  MockArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Foundation
import Combine
@testable import dev_articles

struct MockArticlesRestAdapter: ArticlesRestAdapter {
  let articles: [Article];
  let shouldFail: Bool
  
  func list$() -> AnyPublisher<[Article], RestError> {
    guard !shouldFail else {
      return Fail<[Article], RestError>(error: RestError.serverError).eraseToAnyPublisher()
    }
    return Just(articles).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
  
}
