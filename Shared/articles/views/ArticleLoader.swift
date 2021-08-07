//
//  StaticGetArticleForContentView.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 07.08.21.
//

import Combine
import Foundation

struct StaticArticleLoader: ArticleLoader {
  let article: Article

  func load() -> AnyPublisher<Article?, RepositoryError> {
    Just(article).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}

struct GetArticleArticleLoader: ArticleLoader {
  let getArticle: GetArticle
  let articleId: ArticleId

  init(getArticle: GetArticle, articleId: ArticleId) {
    self.getArticle = getArticle
    self.articleId = articleId
  }

  func load() -> AnyPublisher<Article?, RepositoryError> {
    getArticle.getBy(id: articleId).eraseToAnyPublisher()
  }
}
