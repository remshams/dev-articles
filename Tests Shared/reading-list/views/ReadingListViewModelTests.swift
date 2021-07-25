//
//  ReadingListViewModelTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 25.07.21.
//

@testable import dev_articles
import Foundation
import XCTest

class ReadingListViewModelTests: XCTestCase {
  var article: Article!
  var model: ReadingListViewModel!

  override func setUp() {
    article = Article.createFixture()
    model = ReadingListViewModel()
  }

  func test_add_shouldAddArticleToList() {
    model.add(article: article)

    XCTAssertEqual(model.bookmarkedArticles.count, 1)
    XCTAssertEqual(model.bookmarkedArticles[0].article, BookmarkedArticle.from(article: article).article)
  }
}
