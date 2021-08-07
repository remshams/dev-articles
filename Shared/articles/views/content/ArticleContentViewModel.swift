//
//  ArticleContentViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.07.21.
//

import Combine
import Foundation

enum ArticleContentViewState: Equatable {
  case loading
  case loaded(Article, ArticleContent)
  case error
}

class ArticleContentViewModel: ObservableObject {
  @Published var state: ArticleContentViewState

  private let getArticle: GetArticle
  private let listArticleContent: ListArticleContent
  private let articleId: ArticleId
  private var cancellables: Set<AnyCancellable> = []

  init(getArticle: GetArticle, listArticleContent: ListArticleContent, articleId: ArticleId) {
    self.getArticle = getArticle
    self.listArticleContent = listArticleContent
    self.articleId = articleId
    state = .loading
  }

  func loadContent() {
    getArticle.getBy(id: articleId)
      .combineLatest(listArticleContent.content(for: articleId))
      .map { article, content in
        if let article = article {
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
