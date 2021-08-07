//
//  ArticleContentViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.07.21.
//

import Combine
import Foundation

protocol ArticleLoader {
  func load() -> AnyPublisher<Article?, RepositoryError>
}

enum ArticleContentViewState: Equatable {
  case loading
  case loaded(Article, ArticleContent)
  case error
}

class ArticleContentViewModel: ObservableObject {
  @Published var state: ArticleContentViewState

  private let articleLoader: ArticleLoader
  private let listArticleContent: ListArticleContent
  private var cancellables: Set<AnyCancellable> = []

  init(articleLoader: ArticleLoader, listArticleContent: ListArticleContent) {
    self.articleLoader = articleLoader
    self.listArticleContent = listArticleContent
    state = .loading
  }

  func loadContent() {
    articleLoader.load()
      .flatMap { article -> AnyPublisher<(Article?, ArticleContent?), RepositoryError> in
        guard let article = article else {
          return Just((nil, nil)).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        }
        return self.listArticleContent.content(for: article.id).map { (article, $0) }.eraseToAnyPublisher()
      }
      .map { article, content in
        if let article = article, let content = content {
          return .loaded(article, content)
        } else {
          return .error
        }
      }
      .replaceError(with: ArticleContentViewState.error)
      .assign(to: \.state, on: self)
      .store(in: &cancellables)
  }
}
