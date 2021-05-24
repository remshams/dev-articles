//
//  ArticleTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 24.05.21.
//

@testable import dev_articles
import XCTest

class ArticleTests: XCTestCase {
  var articles: [Article]!

  override func setUp() {
    articles = createArticlesListFixture(min: 2)
  }

  func testBookmark_ShouldBookmarkArticles() {
    var bookmarked = articles[0]
    bookmarked.bookmarked.toggle()
    let articlesBookmarked = [bookmarked] + articles.dropFirst()

    XCTAssertEqual(articles.bookmark(articles: [articles[0]]), articlesBookmarked)
  }

  func testBookmark_ShouldSkipArticleThatCannotBeFound() {
    XCTAssertEqual(articles.bookmark(articles: [createArticleFixture(title: "other")]), articles)
  }
}
