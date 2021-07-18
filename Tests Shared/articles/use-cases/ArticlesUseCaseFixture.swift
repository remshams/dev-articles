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
  let addReadingListItemFromArticleUseCase: MockAddReadingListItemFromArticleUseCase

  init(
    loadArticlesUseCase: MockLoadArticlesUseCase = MockLoadArticlesUseCase(),
    addReadingListItemFromArticleUseCase: MockAddReadingListItemFromArticleUseCase =
      MockAddReadingListItemFromArticleUseCase()
  ) {
    self.loadArticlesUseCase = loadArticlesUseCase
    self.addReadingListItemFromArticleUseCase = addReadingListItemFromArticleUseCase
  }

  func makeLoadArticlesUseCase(timeCategory _: TimeCategory, page: Int, pageSize: Int) -> LoadArticlesUseCase {
    loadArticlesUseCase
  }
  
  func makeLoadArticlesUseCase(timeCategory _: TimeCategory, page: Int) -> LoadArticlesUseCase {
    loadArticlesUseCase
  }

  func makeAddReadlingListItemFromArticleUseCase(article _: Article) -> AddReadingListItemFromArticleUseCase {
    addReadingListItemFromArticleUseCase
  }
}
