//
//  ArticleContentRestDto.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.07.21.
//

import Foundation
import Combine

struct ArticleContentRestDto: Codable {
  // swiftlint:disable identifier_name
  let body_html: String
  // swiftlint:enable identifier_name
}

extension ArticleContentRestDto {
  func toArticleContent() -> ArticleContent {
    ArticleContent(html: body_html)
  }
}

extension Publisher where Output == ArticleContentRestDto {
  func toArticleContent() -> Publishers.Map<Self, ArticleContent> {
    map { $0.toArticleContent() }
  }
}
