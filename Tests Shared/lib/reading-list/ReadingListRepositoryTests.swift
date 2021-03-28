//
//  ReadingListRepositoryTests.swift
//  Tests Shared
//
//  Created by Mathias Remshardt on 27.03.21.
//

import Foundation
import XCTest
import Combine
@testable import dev_articles



class ReadingListRepositoryTests: XCTestCase {
  var article: Article!
  var readingListItem: ReadingListItem!
  var repository: ReadingListCoreDataRepository!
  var cancellables: Set<AnyCancellable>!
  let assertReadlingListItem = { (result: [[ReadingListItem]], expected: [[ReadingListItem]]) in
    XCTAssertEqual(result.count, expected.count)
    (0..<result.count).forEach { indexResult in
      (0...indexResult).forEach { index in
        XCTAssertEqual(result[indexResult][index].articleId, expected[indexResult][index].articleId)
        XCTAssertEqual(result[indexResult][index].link, expected[indexResult][index].link)
        XCTAssertEqual(result[indexResult][index].title, expected[indexResult][index].title)
      }
    }
  }
  
  override func setUp() {
    article = createArticleFixture()
    readingListItem = ReadingListItem(from: article, savedAt: Date())
    repository = ReadingListCoreDataRepository(managedObjectContext: PersistenceController(inMemory: true).container.viewContext)
    cancellables = []
  }
  
  override func tearDown() {
    cancellables = []
  }
  
  func testsAddArticle_ShouldAddArticle() {
    assertStreamEquals(cancellables: &cancellables, received$: repository.addFrom(article: article), expected: [true])
    assertStreamEquals(cancellables: &cancellables, received$: repository.list(), expected: [[readingListItem]], with: assertReadlingListItem)
  }
  
}
