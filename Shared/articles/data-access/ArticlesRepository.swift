//
//  ArticlesRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 01.05.21.
//

import Foundation
import Combine

class AppArticlesRepository: ListArticle {
  private let articlesRestAdapter: ArticlesRestAdapter
  
  init(articlesRestAdapter: ArticlesRestAdapter) {
    self.articlesRestAdapter = articlesRestAdapter
  }
  
  func list(for timeCategory: TimeCategory) -> AnyPublisher<[Article], RepositoryError> {
    articlesRestAdapter.list(for: timeCategory)
  }
}
