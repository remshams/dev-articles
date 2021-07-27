//
//  MockArticlesRestAdapter.swift
//  SharedTests
//
//  Created by Mathias Remshardt on 07.02.21.
//

import Combine
@testable import dev_articles
import Foundation

struct FailingListArticle: ListArticle {
  let listError: RepositoryError

  func list(for _: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError> {
    Fail<[Article], RepositoryError>(error: listError).eraseToAnyPublisher()
  }
  
  func getBy(path: String) -> AnyPublisher<Article?, RepositoryError> {
    Fail<Article?, RepositoryError>(error: listError).eraseToAnyPublisher()
  }
}

struct InMemoryListArticle: ListArticle {
  let articles: [Article]

  func list(for _: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError> {
    Just(articles).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
  
  func getBy(path: String) -> AnyPublisher<Article?, RepositoryError> {
    Just(articles.first ?? Article.createFixture()).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
