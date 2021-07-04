//
//  MockArticleContentRepository.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 04.07.21.
//

import Combine
@testable import dev_articles
import Foundation

struct MockListArticleContent: ListArticleContent {
  let content: ArticleContent

  func content(for _: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError> {
    Just(content).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
  }
}

struct FailingListArticleContent: ListArticleContent {
  func content(for _: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError> {
    Fail<ArticleContent, RepositoryError>(error: RepositoryError.error).eraseToAnyPublisher()
  }
}
