//
//  LoadArticles.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Combine
import Foundation

struct LoadArticlesUseCase {
  let listArticle: ListArticle
  let timeCategory: TimeCategory
}

extension LoadArticlesUseCase: UseCase {
  typealias Success = [Article]
  typealias Failure = Never

  func start() -> AnyPublisher<Success, Failure> {
    return listArticle.list(for: timeCategory)
      .receive(on: DispatchQueue.main)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }
}
