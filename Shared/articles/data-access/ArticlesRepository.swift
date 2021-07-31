//
//  ArticlesRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 31.07.21.
//

import Foundation
import Combine

protocol ListArticle {
  func list(for timeCategory: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError>
}

protocol GetArticle {
  func getBy(url: String) -> AnyPublisher<Article?, RepositoryError>
}

protocol ListArticleContent {
  func content(for id: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError>
}
