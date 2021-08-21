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

enum AddArticleViewError: Error {
  case notFound
  case notLoaded
  case urlInvalid
}

enum AddArticleViewState: Equatable {
  case initial
  case articleLoaded(Article)
  case error(AddArticleViewError)
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

  func loadArticle(for url: String, shouldAdd: Bool = false) {
    if let articleUrl = ArticleUrl(url: url), articleUrl.path != nil {
      getArticle.getBy(url: articleUrl)
        .map { article in
          if let article = article {
            return AddArticleViewState.articleLoaded(article)
          } else {
            return AddArticleViewState.error(.notFound)
          }
        }
        .replaceError(with: AddArticleViewState.error(.notLoaded))
        .sink { state in
          self.state = state
          if shouldAdd {
            self.add()
          }
        }
        .store(in: &cancellables)
    } else {
      state = AddArticleViewState.error(.urlInvalid)
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
