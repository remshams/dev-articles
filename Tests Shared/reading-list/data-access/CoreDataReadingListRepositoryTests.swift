//
//  ReadingListRepositoryTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 27.03.21.
//

import Combine
import CoreData
@testable import dev_articles
import Foundation
import XCTest

class CoreDataReadingListRepositoryTests: XCTestCase {
  var articles: [Article]!
  var article: Article!
  var readingListItems: [ReadingListItem]!
  var readingListItem: ReadingListItem!
  var repository: CoreDataReadingListRepository!
  var cancellables: Set<AnyCancellable>!
  var managedObjectContext: NSManagedObjectContext!

  override func setUp() {
    articles = Article.createListFixture(min: 2)
    article = articles[0]
    readingListItems = articles.map { ReadingListItem(from: $0, savedAt: Date()) }
    readingListItem = readingListItems[0]
    managedObjectContext = PersistenceController(inMemory: true).container.viewContext
    repository = CoreDataReadingListRepository(managedObjectContext: managedObjectContext)
    cancellables = []
  }

  override func tearDown() {
    cancellables = []
  }

  func addReadingListItems(readingListItemsForTest: [ReadingListItem]? = nil) {
    (readingListItemsForTest ?? readingListItems)!.forEach {
      managedObjectContext.insert(ReadingListItemDbDto(context: managedObjectContext, readingListItem: $0))
    }
    do {
      try managedObjectContext.save()
    } catch {
      fatalError()
    }
  }

  func testsAddArticle_ShouldAddFromArticle() {
    collect(stream: repository.addFrom(article: article), collect: 1, cancellables: &cancellables)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { self.assertReadingListItem(expected: [self.readingListItem], result: $0) }
      )
      .store(in: &cancellables)

    collect(stream: repository.list(), collect: 1, cancellables: &cancellables)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { self.assertReadingListItems(expected: [[self.readingListItem]], result: $0) }
      )
      .store(in: &cancellables)
  }

  func testList_ShouldReturnReadingListItems() {
    addReadingListItems()

    collect(stream: repository.list(), collect: 1, cancellables: &cancellables)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { self.assertReadingListItems(expected: [self.readingListItems], result: $0) }
      )
      .store(in: &cancellables)
  }

  func testList_ShouldReturnReadingListItemsFromArticleIds() {
    addReadingListItems()
    let articleIds = [article.id]

    collect(stream: repository.list(for: articleIds), collect: 1, cancellables: &cancellables)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { self.assertReadingListItems(expected: [[self.readingListItem]], result: $0) }
      )
      .store(in: &cancellables)
  }

  func testList_ShouldReturnEmptyListInCaseArticleIdsDoNotExist() {
    addReadingListItems()
    let articleIds = ["99"]

    collect(stream: repository.list(for: articleIds), collect: 1, cancellables: &cancellables)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { self.assertReadingListItems(expected: [[]], result: $0) }
      )
      .store(in: &cancellables)
  }

  func testList_ShouldReturnEmptyListInCaseThereAreNoReadingListItems() {
    collect(stream: repository.list(), collect: 1, cancellables: &cancellables)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { self.assertReadingListItems(expected: [[]], result: $0) }
      )
      .store(in: &cancellables)
  }

  private func assertReadingListItems(expected: [[ReadingListItem]], result: [[ReadingListItem]]) {
    XCTAssertEqual(result.count, expected.count)
    (0 ..< result.count).forEach { indexResult in
      assertReadingListItem(expected: expected[indexResult], result: result[indexResult])
    }
  }

  private func assertReadingListItem(expected: [ReadingListItem], result: [ReadingListItem]) {
    let resultSortedById = result.sorted(by: { Int($0.contentId)! <= Int($1.contentId)! })
    XCTAssertEqual(resultSortedById.count, expected.count)
    (0 ..< resultSortedById.count).forEach { index in
      XCTAssertEqual(expected[index].contentId, resultSortedById[index].contentId)
      XCTAssertEqual(expected[index].link, resultSortedById[index].link)
      XCTAssertEqual(expected[index].title, resultSortedById[index].title)
    }
  }
}
