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

  func list(for _: TimeCategory, page _: Int, pageSize _: Int) -> AnyPublisher<[Article], RepositoryError> {
    Fail<[Article], RepositoryError>(error: listError).eraseToAnyPublisher()
  }

  func getBy(path _: String) -> AnyPublisher<Article?, RepositoryError> {
    Fail<Article?, RepositoryError>(error: listError).eraseToAnyPublisher()
  }
}

struct InMemoryListArticle: ListArticle {
  let articles: [Article]

  func list(for _: TimeCategory, page _: Int, pageSize _: Int) -> AnyPublisher<[Article], RepositoryError> {
    Just(articles).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}

struct InMemoryGetArticle: GetArticle {
  let article: Article?

  func getBy(url _: String) -> AnyPublisher<Article?, RepositoryError> {
    Just(article).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}

struct FailingGetArticle: GetArticle {
  let getError: RepositoryError

  func getBy(url _: String) -> AnyPublisher<Article?, RepositoryError> {
    Fail<Article?, RepositoryError>(error: RepositoryError.error).eraseToAnyPublisher()
  }
}
