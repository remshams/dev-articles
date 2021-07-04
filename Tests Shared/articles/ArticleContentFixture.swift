//
//  ArticleContentFixture.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 04.07.21.
//

@testable import dev_articles
import Foundation

extension ArticleContent {
  static func createFixture(html: String = exampleArticleContent.html) -> ArticleContent {
    ArticleContent(html: html)
  }
}
