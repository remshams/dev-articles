//
//  StaticGetArticle.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 06.08.21.
//

import Combine
import Foundation

struct StaticGetArticle: GetArticle {
  let article: Article

  func getBy(url: ArticleUrl) -> AnyPublisher<Article?, RepositoryError> {
    Just(article)
      .map {
        $0.metaData.link.absoluteString == url.url ? article : nil
      }
      .setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }

  func getBy(id: ArticleId) -> AnyPublisher<Article?, RepositoryError> {
    Just(article)
      .map {
        $0.id == id ? article : nil
      }
      .setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
