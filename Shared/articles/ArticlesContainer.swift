//
//  ArticlesContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation

class ArticlesContainer: ObservableObject {
  let listArticle: ListArticle
  let addReadingListItem: AddReadingListItem
  
  init(listArticle: ListArticle, addReadingListItem: AddReadingListItem) {
    self.listArticle = listArticle
    self.addReadingListItem = addReadingListItem
  }
  
  func makeArticlesViewModel() -> ArticlesViewModel {
    ArticlesViewModel(articlesUseCaseFactory: self, addReadingListItem: addReadingListItem)
  }
  
}

extension ArticlesContainer: ArticlesUseCaseFactory {
  func makeLoadArticlesUseCase(timeCategory: TimeCategory) -> LoadArticlesUseCase {
    LoadArticlesUseCase(listArticle: listArticle, timeCategory: timeCategory)
  }
}
