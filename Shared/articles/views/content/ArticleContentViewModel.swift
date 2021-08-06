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
  let getArticle: GetArticle
  let listArticleContent: ListArticleContent
  // TODO Implement a static version returning article from id
  // The static version is used from the posts list whereas
  // the loading version is used from the reading list
  let article: Article
  var cancellables: Set<AnyCancellable> = []

  init(getArticle: GetArticle, listArticleContent: ListArticleContent, article: Article) {
    self.getArticle = getArticle
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
