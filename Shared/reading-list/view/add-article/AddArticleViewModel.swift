//
//  AddArticleViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 25.07.21.
//

import Combine
import Foundation
import SwiftUI

typealias AddArticle = (Article) -> Void
typealias CancelAddArticle = () -> Void

enum AddArticleViewState: Equatable {
  case initial
  case articleLoaded(Article)
  case error(LocalizedStringKey)
}

class AddArticleViewModel: ObservableObject {
  let addArticle: AddArticle
  let cancelAddArticle: () -> Void
  let getArticle: GetArticle
  var cancellables: Set<AnyCancellable>
  @Published var state: AddArticleViewState = .initial

  init(
    addArticle: @escaping AddArticle,
    cancelAddArticle: @escaping CancelAddArticle,
    getArticle: GetArticle
  ) {
    cancellables = []
    self.addArticle = addArticle
    self.cancelAddArticle = cancelAddArticle
    self.getArticle = getArticle
  }

  func loadArticle(for url: String) {
    if let articleUrl = ArticleUrl(url: url), articleUrl.path != nil {
      getArticle.getBy(url: articleUrl)
        .map { article in
          if let article = article {
            return AddArticleViewState.articleLoaded(article)
          } else {
            return AddArticleViewState.error("Article not found")
          }
        }
        .replaceError(with: AddArticleViewState.error("Article load error"))
        .assign(to: \.state, on: self)
        .store(in: &cancellables)
    } else {
      state = AddArticleViewState.error("Article Url invalid")
    }
  }

  func add() {
    if case let .articleLoaded(article) = state {
      addArticle(article)
    } else {
      cancel()
    }
  }

  func cancel() {
    cancelAddArticle()
  }
}
