//
//  ReadingListItem.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 21.03.21.
//

import Foundation

struct ReadingListItem: Equatable, Identifiable {
  var id: String {
    contentId
  }

  let contentId: String
  let title: String
  let link: URL
  let savedAt: Date
}

extension ReadingListItem {
  init(from article: Article, savedAt: Date) {
    self.init(contentId: article.id, title: article.title, link: article.metaData.link, savedAt: savedAt)
  }
}
