//
//  ArticlesUseCase.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Combine
import Foundation

protocol LoadArticlesUseCase {
  func start() -> AnyPublisher<[Article], Never>
}

protocol ArticlesUseCaseFactory {
  func makeLoadArticlesUseCase(timeCategory: TimeCategory, page: Int, pageSize: Int) -> LoadArticlesUseCase
  func makeLoadArticlesUseCase(timeCategory: TimeCategory, page: Int) -> LoadArticlesUseCase
  func makeAddReadlingListItemFromArticleUseCase(article: Article) -> AddReadingListItemFromArticleUseCase
}
