//
//  ArticlesRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 31.07.21.
//

import Combine
import Foundation

protocol ListArticle {
  func list(for timeCategory: TimeCategory, page: Int, pageSize: Int) -> AnyPublisher<[Article], RepositoryError>
}

protocol GetArticle {
  func getBy(url: ArticleUrl) -> AnyPublisher<Article?, RepositoryError>
}

protocol ListArticleContent {
  func content(for id: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError>
}
