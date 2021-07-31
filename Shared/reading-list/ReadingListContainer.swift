//
//  ReadingListContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import Foundation

class ReadingListContainer: ObservableObject {
  let addReadingListItem: AddReadingListItem
  let listReadingListItem: ListReadingListItem
  let getArticle: GetArticle

  init(addReadingListItem: AddReadingListItem, listReadingListItem: ListReadingListItem, getArticle: GetArticle) {
    self.addReadingListItem = addReadingListItem
    self.listReadingListItem = listReadingListItem
    self.getArticle = getArticle
  }

  func makeAddArticleViewModel(addArticle: @escaping AddArticle,
                               cancelAddArticle: @escaping CancelAddArticle) -> AddArticleViewModel {
    AddArticleViewModel(addArticle: addArticle, cancelAddArticle: cancelAddArticle, getArticle: getArticle )
  }
}
