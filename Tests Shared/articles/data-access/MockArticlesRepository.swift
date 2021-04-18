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
  func list(for timeCategor: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    Just([]).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}

protocol FailingListArticle: ListArticle {
  var listError: RepositoryError { get }
}

extension FailingListArticle {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    Fail<[Article], RepositoryError>(error: listError).eraseToAnyPublisher()
  }
}

protocol InMemoryListArticle: ListArticle {
  var articles: [Article] { get set }
}

extension InMemoryListArticle {
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    Just(articles).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}
