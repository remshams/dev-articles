//
//  ReadingListContainer.swift
//  dev-articles (iOS)
//
//  Created by Mathias Remshardt on 17.04.21.
//

import CoreData
import Foundation

class ReadingListContainer: ObservableObject {
  let context: NSManagedObjectContext
  let getArticle: GetArticle

  init(context: NSManagedObjectContext, getArticle: GetArticle) {
    self.context = context
    self.getArticle = getArticle
  }

  func makeAddArticleViewModel(addArticle: @escaping AddArticle,
                               cancelAddArticle: @escaping CancelAddArticle) -> AddArticleViewModel {
    AddArticleViewModel(addArticle: addArticle, cancelAddArticle: cancelAddArticle, getArticle: getArticle)
  }

  func makeArticleContentView(articleId: ArticleId) -> ArticleContentView {
    ArticleContentView(articleLoader: GetArticleArticleLoader(getArticle: getArticle, articleId: articleId))
  }

  func makeReadingListViewModel() -> ReadingListViewModel {
    ReadingListViewModel(context: context)
  }
}
