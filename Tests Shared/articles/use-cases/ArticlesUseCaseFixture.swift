//
//  ArticlesUseCase.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 23.05.21.
//

import Combine
@testable import dev_articles
import Foundation

struct MockLoadArticlesUseCase: LoadArticlesUseCase {
  let articles: [Article]

  init(articles: [Article] = Article.createListFixture()) {
    self.articles = articles
  }

  func start() -> AnyPublisher<[Article], Never> {
    Just(articles).eraseToAnyPublisher()
  }
}

struct MockArticleUseCaseFactory: ArticlesUseCaseFactory {
  let loadArticlesUseCase: MockLoadArticlesUseCase

  init(
    loadArticlesUseCase: MockLoadArticlesUseCase = MockLoadArticlesUseCase()
  ) {
    self.loadArticlesUseCase = loadArticlesUseCase
  }

  func makeLoadArticlesUseCase(timeCategory _: TimeCategory, page _: Int, pageSize _: Int) -> LoadArticlesUseCase {
    loadArticlesUseCase
  }

  func makeLoadArticlesUseCase(timeCategory _: TimeCategory, page _: Int) -> LoadArticlesUseCase {
    loadArticlesUseCase
  }
}
