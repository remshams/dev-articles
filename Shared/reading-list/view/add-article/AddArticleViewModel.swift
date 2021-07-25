//
//  AddArticleViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 25.07.21.
//

import Foundation
import SwiftUI

typealias AddArticle = (Article) -> Void
typealias CancelAddArticle = () -> Void

class AddArticleViewModel: ObservableObject {
  let addArticle: AddArticle
  let cancelAddArticle: () -> Void
  @Published var article: Article?

  init(addArticle: @escaping AddArticle, cancelAddArticle: @escaping CancelAddArticle) {
    self.addArticle = addArticle
    self.cancelAddArticle = cancelAddArticle
  }

  func loadArticle(for _: String) {
    article = articleForPreview
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
