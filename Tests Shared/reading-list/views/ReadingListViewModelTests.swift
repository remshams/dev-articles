//
//  ReadingListViewModelTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 25.07.21.
//

import CoreData
@testable import dev_articles
import Foundation
import SwiftUI
import XCTest

class ReadingListViewModelTests: XCTestCase {
  var article: Article!
  var model: ReadingListViewModel!
  var context: NSManagedObjectContext!

  override func setUp() {
    AppContainer.shared.persistence.context.reset()
    article = Article.createFixture()
    context = AppContainer.shared.persistence.context
    model = ReadingListViewModel(context: context)
  }

  func test_add_shouldAddArticleToList() throws {
    model.add(article: article)

    let readingListItems = try context.fetch(ReadingListItem.fetchRequest(articleIds: [article.id]))
    XCTAssertFalse(readingListItems.isEmpty)
    XCTAssertEqual(readingListItems.first!.title, article.title)
    XCTAssertEqual(readingListItems.first!.contentId, article.id)
  }

  func test_add_shouldIgnoreArticleIfAlreadyInList() throws {
    let otherArticle = Article.createFixture(id: "otherId")
    model.add(article: article)
    model.add(article: otherArticle)
    model.add(article: article)
    model.add(article: otherArticle)

    let readingListItems = try context.fetch(ReadingListItem.fetchRequest(articleIds: [article.id, otherArticle.id]))
    XCTAssertEqual(readingListItems.count, 2)
  }

  func test_remove_shouldRemoveExistingReadingListItem() throws {
    let readingListItem = ReadingListItem(context: context, title: "remove", contentId: "0")
    model.remove(readingListItem: readingListItem)

    let readingListItems = try context.fetch(ReadingListItem.fetchRequestAll())
    XCTAssertEqual(readingListItems.count, 0)
  }
}
