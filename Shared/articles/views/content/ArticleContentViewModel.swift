//
//  ArticleContentViewModel.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.07.21.
//

import Combine
import Foundation

class ArticleContentViewModel: ObservableObject {
  @Published var content = ArticleContent.createEmpty()
  let listArticleContent: ListArticleContent
  let article: Article
  var cancellables: Set<AnyCancellable> = []

  init(listArticleContent: ListArticleContent, article: Article) {
    self.listArticleContent = listArticleContent
    self.article = article
  }

  func loadContent() {
    listArticleContent.content(for: article.id)
      .replaceError(with: ArticleContent.createEmpty())
      .assign(to: \.content, on: self)
      .store(in: &cancellables)
  }
}
