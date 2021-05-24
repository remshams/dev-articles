//
//  ArticlesUseCase.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 02.05.21.
//

import Foundation
import Combine

protocol LoadArticlesUseCase {
  func start() -> AnyPublisher<[Article], Never>
}

protocol ArticlesUseCaseFactory {
  func makeLoadArticlesUseCase(timeCategory: TimeCategory) -> LoadArticlesUseCase
  func makeAddReadlingListItemFromArticleUseCase(article: Article) -> AddReadingListItemFromArticleUseCase
}
