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
  
  func list$() -> AnyPublisher<[Article], RestError> {
    Just(articles).setFailureType(to: RestError.self).eraseToAnyPublisher()
  }
  
}
