//
//  ArticleContentRestDtoFixture.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 04.07.21.
//

import Foundation
@testable import dev_articles

extension ArticleContentRestDto {
  static func createFixture(html: String = exampleArticleContent.html) -> ArticleContentRestDto {
    ArticleContentRestDto(body_html: html)
  }
}
