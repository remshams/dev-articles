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
    AppContainer.shared.persistence.context.reset()
    article = Article.createFixture()
    model = ReadingListViewModel()
  }

  func test_add_shouldAddArticleToList() throws {
    model.add(article: article)

    XCTAssertEqual(model.bookmarkedArticles.count, 1)
    XCTAssertEqual(model.bookmarkedArticles[0].article, BookmarkedArticle.from(article: article).article)
    let readingListItems = try AppContainer.shared.persistence.context
      .fetch(ReadingListItem.fetchRequestAll())
    XCTAssertEqual(readingListItems.count, 1)
    XCTAssertEqual(readingListItems.first!.title, article.title)
    XCTAssertEqual(readingListItems.first!.contentId, article.id)
  }

  func test_add_shouldIgnoreArticleIfAlreadyInList() {
    let otherArticle = Article.createFixture(id: "otherId")
    model.add(article: article)
    model.add(article: otherArticle)
    model.add(article: article)
    model.add(article: otherArticle)

    XCTAssertEqual(model.bookmarkedArticles.count, 2)
  }
}
