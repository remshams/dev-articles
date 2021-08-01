//
//  AppArticleContentRestAdapter.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 04.07.21.
//

import Combine
import Foundation
import OSLog

struct AppArticleContentRestAdapter {
  let httpGet: HttpGet

  func content(for id: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError> {
    httpGet.get(for: URL(string: "\(articlesUrl)/\(id)")!)
      .decode()
      .toArticleContent()
      .mapError { error in
        Logger().debug("Requesting article content failed with: \(error.localizedDescription)")
        return RepositoryError.error
      }
      .eraseToAnyPublisher()
  }
}
