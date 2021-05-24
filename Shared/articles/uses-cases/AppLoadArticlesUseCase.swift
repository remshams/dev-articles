//
//  LoadArticles.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Combine
import Foundation

struct AppLoadArticlesUseCase {
  let listArticle: ListArticle
  let timeCategory: TimeCategory
}

extension AppLoadArticlesUseCase: LoadArticlesUseCase {
  typealias Success = [Article]
  typealias Failure = Never

  func start() -> AnyPublisher<Success, Failure> {
    listArticle.list(for: timeCategory)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }
}
