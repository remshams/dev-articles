//
//  InMemoryArticleContentRepository.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.07.21.
//

import Foundation
import Combine

class InMemoryArticleContentRepository: ListArticleContent {
  func content(for id: ArticleId) -> AnyPublisher<ArticleContent, RepositoryError> {
    #if DEBUG
    Just(exampleArticleContent).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
    #else
    Just(ArticleContent.createEmpty()).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
    #endif
  }
}
