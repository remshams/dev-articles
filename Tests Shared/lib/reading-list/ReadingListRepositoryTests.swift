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
    collect(stream$: repository.addFrom(article: article), collect: 1, cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }, receiveValue: { self.assertReadingListItem(expected: [self.readingListItem], result: $0) })
      .store(in: &cancellables)
    
    collect(stream$: repository.list(), collect: 1, cancellables: &cancellables)
      .sink(receiveCompletion: { _ in }, receiveValue: { self.assertReadingListItems(expected: [[self.readingListItem]], result: $0) })
      .store(in: &cancellables)
  }
  
  private func assertReadingListItems(expected: [[ReadingListItem]], result: [[ReadingListItem]]) -> Void {
    XCTAssertEqual(result.count, expected.count)
    (0..<result.count).forEach { indexResult in
      assertReadingListItem(expected: expected[indexResult], result: result[indexResult])
    }
  }
  
  private func assertReadingListItem(expected: [ReadingListItem], result: [ReadingListItem]) -> Void {
    XCTAssertEqual(result.count, expected.count)
    (0..<result.count).forEach { index in
      XCTAssertEqual(expected[index].articleId, result[index].articleId)
      XCTAssertEqual(expected[index].link, result[index].link)
      XCTAssertEqual(expected[index].title, result[index].title)
    }
    
  }
  
}
