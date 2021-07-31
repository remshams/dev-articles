//
//  AddArticleViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 25.07.21.
//

import Foundation
import SwiftUI
import Combine

typealias AddArticle = (Article) -> Void
typealias CancelAddArticle = () -> Void

class AddArticleViewModel: ObservableObject {
  let addArticle: AddArticle
  let cancelAddArticle: () -> Void
  let getArticle: GetArticle
  var cancellables: Set<AnyCancellable>
  @Published var article: Article?

  init(
    addArticle: @escaping AddArticle,
    cancelAddArticle: @escaping CancelAddArticle,
    getArticle: GetArticle
  ) {
    self.cancellables = []
    self.addArticle = addArticle
    self.cancelAddArticle = cancelAddArticle
    self.getArticle = getArticle
  }

  func loadArticle(for url: String) {
    getArticle.getBy(url: url)
      .replaceError(with: nil)
      .assign(to: \.article, on: self)
      .store(in: &cancellables)
  }

  func add() {
    if let article = article {
      addArticle(article)
    } else {
      cancel()
    }
  }

  func cancel() {
    cancelAddArticle()
  }
}
