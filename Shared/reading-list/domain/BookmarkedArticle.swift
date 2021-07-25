//
//  BookmarkedArticle.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 24.07.21.
//

import Foundation

struct BookmarkedArticle: Identifiable, Equatable {
  let savedAt: Date
  let article: Article
  var id: String {
    article.id
  }
}

extension BookmarkedArticle {
  static func from(article: Article, savedAt: Date = Date()) -> BookmarkedArticle {
    BookmarkedArticle(savedAt: savedAt, article: article)
  }
}

#if DEBUG

  let bookmarkedArticleForPreview = BookmarkedArticle(savedAt: Date(), article: articleForPreview)
#endif
