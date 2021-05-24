//
//  ArticlesUseCase.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Foundation
import Combine
@testable import dev_articles

struct MockLoadArticesUseCase: LoadArticlesUseCase {
  let articles: [Article]
  
  init(articles: [Article] = createArticlesListFixture()) {
    self.articles = articles
  }
  
  func start() -> AnyPublisher<[Article], Never> {
    Just(articles).eraseToAnyPublisher()
  }
}
