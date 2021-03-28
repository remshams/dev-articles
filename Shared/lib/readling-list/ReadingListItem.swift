//
//  ReadingListItem.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Foundation

struct ReadingListItem: Equatable {
  let articleId: Int
  let title: String
  let link: URL
  let savedAt: Date
}

extension ReadingListItem {
  init(from article: Article, savedAt: Date) {
    self.init(articleId: article.id, title: article.title, link: article.link, savedAt: savedAt)
  }
}
